(** Remove file `filename` if it exists *)
let remove_if_exist filename =
  if Sys.file_exists filename then Sys.remove filename

(** Add a line tag to a svg file *)
let add_svg_line
  width
  height
  c_out
  (pos1: Turtle.position)
  (pos2 : Turtle.position)
  (c : Graphics.color) =
  Printf.fprintf c_out
    "<line style=\"stroke:#%06x;stroke-width:%d\" \
     x1=\"%f\" x2=\"%f\" y1=\"%f\" y2=\"%f\"/>\n"
    c width pos1.x pos2.x (800. -. pos1.y) (800. -. pos2.y)

(** Draw line in svg file *)
let line width height t n f c_out =
  let t' = Turtle.update_pos t n f in
  let pos = Turtle.turtle_pos t in
  let pos' = Turtle.turtle_pos t' in
  let c = Turtle.turtle_color t in
  let width = Turtle.turtle_width t in
  let _ = add_svg_line width height c_out pos pos' c in
  t'

(** Exec Turtle.command list in a svg file *)
let rec exec width height c_out f t l =
  match l with
  | [] -> t
  |  x :: l' -> let t' = match x with
    | Turtle.Line n -> line width height t n f c_out
    | Turtle.Move n -> Turtle.update_pos t n f
    | _ -> Turtle.exec f t [x] in
    exec width height c_out f t' l'

(** Draw a lsystem in a svg file *)
let write_content_of_svg sys c_out width height =
  let factor, t_x, t_y, start_width = Systems.compute_scales width height sys in
  let t = Turtle.create_turtle_at t_x t_y start_width in
  Systems.iter_word sys.axiom sys.interp (exec width height c_out factor) t

(** Save a lsystems's image into a svg file *)
let save sys filename width height =
  let _ = remove_if_exist in
  let c_out = open_out filename in
  let _  = Printf.fprintf c_out
      "<svg xmlns=\"http://www.w3.org/2000/svg\" \
       version=\"1.1\" width=\"%d\" height=\"%d\">\n"
  width height in
  let _ = write_content_of_svg sys c_out width height in
  let _ = output_string c_out "</svg>\n" in
  close_out c_out
