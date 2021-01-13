open Turtle
(** Words, rewrite systems, and rewriting *)

type 's word =
  | Symb of 's
  | Seq of 's word list
  | Branch of 's word

type 's rewrite_rules = 's -> 's word

type 's system = {
    axiom : 's word;
    rules : 's rewrite_rules;
    interp : 's -> Turtle.command list }

(** Put here any type and function implementations concerning systems *)
(** Computing the right scale *)


(* Coordonnées de départ de la tortue *)
let turtle_start_x = 0.0
let turtle_start_y = 0.0


let rec iter_word word interp exec a =
  match word with
  | Symb symb -> iter_symb symb interp exec a
  | Branch branch -> iter_branch branch interp exec a
  | Seq seq -> iter_seq seq interp exec a

and iter_symb symb interp exec a =
  exec a (interp symb)

and iter_seq seq interp exec a =
  match seq with
  | [] -> a
  | w :: seq' -> let a' = iter_word w interp exec a
    in iter_seq seq' interp exec a'

and iter_branch branch interp exec a =
  let a1 = exec a [Store] in
  let a2 = iter_word branch interp exec a1 in
  exec a2 [Restore]


(* Calcule le nouveau coin haut-gauche
 * en fonction de la position de la tortue
*)
let update_up_left turtle up_left =
  let pos = turtle_pos turtle in
  { up_left with x = min up_left.x pos.x; y = max up_left.y pos.y }

(* Calcule le nouveau coin bas-droite en fonction de la position de la tortue *)
let update_down_right turtle down_right =
  let pos = turtle_pos turtle in
  { down_right with x = max down_right.x pos.x; y = min down_right.y pos.y }

(* On ne veut pas dessiner durant le calcul de l'échelle *)
let frame_interp interp x =
  interp x |> List.map (fun cmd -> match cmd with
      | Line n -> Move n
      | Color c -> Color 0
      | c -> c )


let rec frame_exec exec (turtle, up_left, down_right, min_width) cmd =
  match cmd with
  | [] -> (turtle, up_left, down_right, min_width)
  | x :: cmd ->
    let turtle' = exec turtle [x] in
    frame_exec
      exec
      (
        turtle', (update_up_left turtle' up_left),
        (update_down_right turtle' down_right),
        (min min_width (Turtle.turtle_width turtle'))
      )
      cmd

(** Compute the minimal rectangle framing the lsystem *)
let frame_system sys =
  let interp = frame_interp sys.interp in
  let exec = frame_exec (Turtle.exec 1.) in
  let turtle = Turtle.create_turtle_at turtle_start_x turtle_start_y 0 in
  let pos = turtle_pos turtle in
  let _, up_left, down_right, min_width =
    iter_word
      sys.axiom
      interp
      exec
      (turtle, pos, pos, 0) in
  up_left, down_right, min_width


(* Calcule le facteur d'agrandissement tel que le rectangle encadrant soit le
 * plus grand possible sans sortir de la fenêtre *)
let scale_factor window_height window_width frame_height frame_width =
  min (window_height /. frame_height) (window_width /. frame_width)


let new_turtle_start_x window_width up_left down_right turtle_x factor =
  (window_width /. 2.) -.
  factor *. ((up_left.x +. down_right.x) /. 2.) +. turtle_x *. (factor -. 1.)

let new_turtle_start_y window_height up_left down_right turtle_y factor =
  (window_height /. 2.) -.
  factor *. ((up_left.y +. down_right.y) /. 2.) +. turtle_y *. (factor -. 1.)

let compute_factor width height sys =
  let padding = 50. in
  let ul, dr, mw = frame_system sys in

  let window_width = (Float.of_int width) -. padding in
  let window_height = (Float.of_int height) -. padding in
  let frame_height = Float.abs (ul.y -. dr.y) in
  let frame_width = Float.abs (dr.x -. ul.x) in

  let factor =
    scale_factor window_height window_width frame_height frame_width in
  let turtle_x = new_turtle_start_x
      (window_width +. padding) ul dr turtle_start_x factor in
  let turtle_y = new_turtle_start_y
      (window_height +. padding) ul dr turtle_start_y factor in
  factor, turtle_x, turtle_y, (1 - mw)


(** Draw the given lsystem with right scale *)
let draw_system sys =

  let factor, turtle_x, turtle_y, start_width =
    compute_factor (Graphics.size_x ()) (Graphics.size_y ()) sys in
  let turtle = Turtle.create_turtle_at turtle_x turtle_y start_width in
  let _ = iter_word sys.axiom sys.interp (Turtle.exec factor) turtle in
  ();;


let rec next_symb rules symb i =
  if i = 0 then Symb symb
  else next_word rules (rules symb) (i-1)

and next_seq rules seq i =
  let rec next_seq_list seq = match seq with
    | [] -> []
    | x :: l -> (next_word rules x i) :: (next_seq_list l)
  in Seq (next_seq_list seq)

and next_branch rules branch i =
  if i = 0 then Branch branch
  else
    Branch (next_word rules branch i)

and next_word rules word i =
  if i = 0 then word
  else match word with
       | Symb sym -> next_symb rules sym i
       | Branch bra -> next_branch rules bra i
       | Seq seq -> next_seq rules seq i

let next sys i =
  if i < 0 then raise (Invalid_argument "valeur de l'iteration < 0")
  else
    { sys with axiom = next_word sys.rules sys.axiom i}
