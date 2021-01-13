
(** Turtle graphical commands *)
type command =
| Line of int  (** advance turtle while drawing *)
| Move of int  (** advance without drawing *)
| Turn of int  (** turn turtle by n degrees *)
| Store (** save the current state of the turtle *)
| Restore (** restore the last saved state not yet restored *)
| Color of Graphics.color (** Change the current color of turtle *)
| Increase (** Increase line width of turtle *)
| Decrease (** Decrease line width of turtle *)

(** Position and angle of the turtle *)
type position = {
  x: float;        (** position x *)
  y: float;        (** position y *)
  a: int;          (** angle of the direction *)
}

type turtle

(** Create turtle at given positions *)
val create_turtle_at : float -> float -> int -> turtle

(** Get turtle's current position *)
val turtle_pos : turtle -> position

(** Exec turtle commands list *)
val exec : float -> turtle -> command list -> turtle

(** Update position of a turtle *)
val update_pos : turtle -> int -> float -> turtle

(** Get turtle's color *)
val turtle_color : turtle -> Graphics.color

(** Get turtle's width *)
val turtle_width : turtle -> int
