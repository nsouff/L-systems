(** Wait user input command and do the appropriate action *)
val wait : 's Systems.system -> 's Systems.system -> int -> unit

exception Quit
