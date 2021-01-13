type command =
  | Line of int
  | Move of int
  | Turn of int
  | Store
  | Restore
  | Color of Graphics.color
  | Increase
  | Decrease

type position = {
    x: float;      (** position x *)
    y: float;      (** position y *)
    a: int;        (** angle of the direction *)
  }


type turtle = {
    pos : position;
    states : (position * Graphics.color * int) list;
    color : Graphics.color;
    width : int;
  }

(** Create a new turtle at position (`x`,`y`) of width `width` *)
let create_turtle_at x y width =
  Graphics.moveto (Int.of_float x) (Int.of_float y);
  Graphics.set_line_width width;
  let pos = {x = x; y = y; a = 90} in
  { pos = pos; states = []; color = Graphics.black; width = width }


(** Get turtle's position *)
let turtle_pos turtle =
  turtle.pos

(** Get turtle's color *)
let turtle_color t =
  t.color

(** Get turtle's width *)
let turtle_width t =
  t.width


(** Degree to radian *)
let radian_of_degree deg =
  deg *. (Float.pi /. 180.);;

(** Advance turtle t by n times f which represents a factor units *)
let update_pos t n f =
  let cur_pos = t.pos in
  let a' = radian_of_degree (Float.of_int cur_pos.a) in
  let dist = (float_of_int n) *. f in
  let new_x = (Float.cos a' *. dist) +. cur_pos.x in
  let new_y = (Float.sin a' *. dist) +. cur_pos.y in
  let new_pos = { t.pos with x = new_x; y = new_y } in
  { t with pos = new_pos }


(** Set a turtle color, Graphics color and returns the new turtle *)
let set_color turtle color =
  let _ = Graphics.set_color color in
  { turtle with color = color }

(** Set width of turtle and Graphics line width if possible.
 * Returns the new turtle
*)
let set_width turtle width =
  let t = { turtle with width = width} in
  try
    let _ = Graphics.set_line_width width in
    t
  with Invalid_argument s -> t

(** Draw line of size n times f and returns a new turtle with the
 * updated position
*)
let line t n f =
  let t' = update_pos t n f in
  Graphics.lineto (Float.to_int t'.pos.x) (Float.to_int t'.pos.y);
  t'

(** Move a turtle and the Graphics cursor of a line of size n times f
 * Returns the new updated turtle
*)
let move t n f =
  let t' = update_pos t n f in
  Graphics.moveto (Float.to_int t'.pos.x) (Float.to_int t'.pos.y);
  t'

(** Add angle to a turtle angle and returns the new turtle *)
let turn t angle =
  let new_pos = { t.pos with a = t.pos.a + angle } in
  { t with pos = new_pos }

(** Store the cuurent state of a turtle *)
let store t =
  { t with states = (t.pos, t.color, t.width) :: t.states }

(** Restore the last state of a turtle and returns it *)
let restore t =
  match t.states with
  | [] -> failwith "No more state"
  | (p, c, w) :: l' -> Graphics.moveto (Float.to_int p.x) (Float.to_int p.y);
    let t' = set_color (set_width t w) c in
    { t' with pos = p; states = l'}

(** Exec a turtle command list with a factor *)
let rec exec f t l =
  match l with
  | [] -> t
  | x :: l' -> let t' = match x with
      | Line n -> line t n f
      | Move n -> move t n f
      | Turn n -> turn t n
      | Store -> store t
      | Restore -> restore t
      | Color c -> set_color t c
      | Increase -> set_width t (t.width + 1)
      | Decrease -> set_width t (t.width - 1) in
    exec f t' l'
