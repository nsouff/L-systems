exception Quit

let print_on_space () =
  print_string "Dessine..."; print_newline ()

let print_on_plus () =
  print_string "Calcul de l'itération suivante..."; print_newline ()

let print_on_minus () =
  print_string "Calcul de l'itération précédente..."; print_newline ()

let print_on_number x =
  Printf.printf "Calcul de l'itération n°%c" x; print_newline ()

let save_command sys =
  let _ = print_string "Sauvegarde..." in
  let _ = print_newline () in
  let _ = To_svg.save sys "lsystem.svg" in
  let _ = print_string "Fini" in
  print_newline ()

let draw_number_of_system i =
  let _ = Graphics.moveto 0 0 in
  (try Graphics.set_font "-bitstream-*-*-r-normal-*-20-*-*-*-*-*-*-*" with _ ->
   try Graphics.set_font "-*-fixed-medium-r-semicondensed-*-20-*-*-*-*-*-iso8859-1"
   with _ -> ());
  let s = Printf.sprintf "Iteration courante: %d" i in
  let _ = Graphics.draw_string s in
  ()

let print_not_found c =
  Printf.printf
    "Command inconnue: %c, voir --usage pour les commandes supportées" c;
  print_newline ()
let rec wait or_sys cur_sys cur_index =
  let rec cmd_pressed () =
    let ev = Graphics.wait_next_event [Graphics.Key_pressed] in
    if ev.keypressed
    then match ev.key with
      | 'q' -> raise Quit
      | ' ' ->
        print_on_space ();
        Graphics.clear_graph ();
        Graphics.set_color Graphics.black;
        Systems.draw_system cur_sys;
        draw_number_of_system cur_index;
        cmd_pressed ()
      | '+' ->
        print_on_plus ();
        wait or_sys (Systems.next cur_sys 1) (cur_index + 1)
      | '-' ->
        print_on_minus ();
        wait or_sys (Systems.next or_sys (cur_index - 1)) (cur_index - 1)
      | 's' -> save_command cur_sys;
        cmd_pressed ()
      | '0'.. '9' as x ->
        print_on_number x;
        let n = (Char.code x) - (Char.code '0') in
        if n >= cur_index then wait or_sys (Systems.next cur_sys (n - cur_index)) n
        else wait or_sys (Systems.next or_sys n) n
      | x -> print_not_found x; cmd_pressed ()
    else cmd_pressed ()
  in cmd_pressed ()
