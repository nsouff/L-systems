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

(** Put here any type and function interfaces concerning systems *)
val draw_system : 's system -> unit
val next : 's system ->  int -> 's system
val iter_word :
  'a word ->
  ('a -> Turtle.command list) ->
  ('b -> Turtle.command list -> 'b) ->
  'b ->
  'b

(** Compute factor of line, scale of window and starting width of lines
 * to draw a lsystem
*)
val compute_scales : int -> int -> 's system -> float * float * float * int
