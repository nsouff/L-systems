open Lsystems (* Librairie regroupant le reste du code. Cf. fichier dune *)

(** Gestion des arguments de la ligne de commande.
    Nous suggérons l'utilisation du module Arg
    http://caml.inria.fr/pub/docs/manual-ocaml/libref/Arg.html
*)

let what = (* Entete du message d'aide pour --help *)
  "Interpretation de L-systemes et dessins fractals"

let usage =
  "Mettre un chemin vers un fichier décrivant un L-systemes en paramètre\n"
  ^"  Commandes possible:\n"
  ^"  <space>: déssine le L-systemes courant\n"
  ^"  <+>: Calcul l'itération suivante du L-systemes courant\n"
  ^"  <->: Calcul l'itération précédente du L-systemes courant\n"
  ^"  <0> à <9>: Calcul la i-ième itération du L-systemes chargé inital\n"
  ^"  <s>: Sauvegarde le L-systemes courant en image vectoriel dans lsystem.svg\
    \n"
^"  <q>: Quitter"


let action_what () = Printf.printf "%s\n" what; exit 0

let action_usage () = Printf.printf "%s\n" usage; exit 0

let cmdline_options = [
  ("--what" , Arg.Unit action_what, "description");
  ("--usage", Arg.Unit action_usage, "utilisation");
]

let extra_arg_action = fun s -> let sys = Parser.parse_system s in
  let _ = Graphics.open_graph " 800x800" in
  let _ = Graphics.set_window_title "L-Systeme" in
  Command.wait sys sys 0

let main () =
  try
    Arg.parse cmdline_options extra_arg_action what;
    action_usage ()
  with
  | Command.Quit ->
    let _ = print_string "Au revoir!"; print_newline () in
    exit 0

(** On ne lance ce main que dans le cas d'un programme autonome
    (c'est-à-dire que l'on est pas dans un "toplevel" ocaml interactif).
    Sinon c'est au programmeur de lancer ce qu'il veut *)

let () = if not !Sys.interactive then main ()
