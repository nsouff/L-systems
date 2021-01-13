open Systems

(* Finds branch start (i.e. '[') in the String
 * [inf, branch_end] of s.
 * We suppose that branch_end is the end of the branch
 * (i.e s.[branch_end] = ']')
*)
let find_branch_start s inf branch_end =
  let rec rloop i nb =
    if nb < 0 || i < inf then failwith "Unbalanced branch"
    else match s.[i] with
         | '[' -> if nb = 0 then i else rloop (i - 1) (nb - 1)
         | ']' -> rloop (i - 1) (nb + 1)
         |  _  -> rloop (i - 1) nb in
  rloop (branch_end - 1) 0;;


(** Parse a word in the sub-string [inf, sup[ of s *)
let rec parse_word s inf sup =
  if sup - inf = 1 then Symb s.[inf] else
    if s.[sup - 1] = ']' && inf = find_branch_start s inf (sup - 1) then
      Branch (parse_word s (inf + 1) (sup - 1)) else
      parse_seq s inf sup []

(** Parse a sequence in the sub-string [inf, sup[ of s *)
and parse_seq s inf sup acc =
  if sup - inf = 0 then Seq acc else
    if s.[sup - 1] = ']' then
      let bs = find_branch_start s inf (sup - 1) in (*bs : branch start *)
      parse_seq s inf bs ((parse_word s bs sup) :: acc) else
      parse_seq s inf (sup - 1) ((Symb s.[sup - 1]) :: acc);;

(** Convert a string into a char word *)
let word_of_string s =
  let len = String.length s in
  if len = 0 then raise (Invalid_argument "empty string")
  else parse_word s 0 len;;


(** Creates a math function form an associations list
 * if an argument is not in the list then it uses function default
*)
let create_match_function assoc default =
  fun c -> match List.assoc_opt c assoc with
    | None -> default c
    | Some r -> r

(** Returns next token s i.e the next string after the first space  *)
let next_token s =
  match String.index_opt s ' ' with
  | None -> None
  | Some i -> Some (String.sub s (i+1) (String.length s - (i+1)))

(** The string has this format: ###,###,### *)
let color_of_string s =
  let red = String.sub s 0 3 |> int_of_string in
  let green = String.sub s 4 3 |> int_of_string in
  let blue = String.sub s 8 3 |> int_of_string in
  Graphics.rgb red green blue

(** Craetes a Turtle.command list form a string *)
let command_list_of_string s =
  let command_of_string s =
    let len = match String.index_opt s ' ' with
      | None -> (String.length s) - 1
      | Some i -> (i-1) in
    match s.[0] with
    | 'T' -> Turtle.Turn ((String.sub s 1 len) |> int_of_string)
    | 'M' -> Turtle.Move ((String.sub s 1 len) |> int_of_string)
    | 'L' -> Turtle.Line ((String.sub s 1 len) |> int_of_string)
    | 'S' -> Turtle.Store
    | 'R' -> Turtle.Restore
    | 'C' -> Turtle.Color (color_of_string (String.sub s 1 len))
    | 'I' -> Turtle.Increase
    | 'D' -> Turtle.Decrease
    |  _  -> raise (Invalid_argument "bad pattern");
  in let rec append_command_list_of_string s l =
       match s with
       | None -> List.rev l
       | Some s -> let cmd = command_of_string s in
         append_command_list_of_string (next_token s) (cmd :: l)
     in if String.length s = 0 then []
        else append_command_list_of_string (Some s) []

(** Returns true if and only if the size of the line is 0 *)
let is_empty_line line =
  String.length line = 0

(** Returns a String option which is the next line of input channel it exists
 * else None
*)
let rec next_line ic =
  try
    let line = input_line ic in
    if is_empty_line line then None
    else if line.[0] = '#' then next_line ic
    else Some line
  with End_of_file -> None

(** Read next line of input channel *)
let skip_next_line ic = input_line ic

let parse_axiom ic =
  let res = match next_line ic with
    | None -> raise (Invalid_argument "bad pattern")
    | Some line -> word_of_string line
  in let _ = skip_next_line ic in
  res

(** Returns a pair with first elements fixed to s.[0] and second is found
 * by launching f on the rest of the string
*)
let pair_of_string s f =
  let second = String.sub s 2 ((String.length s) - 2) in
  (s.[0], f second)

(** Create an associations list using a function f to have the second element *)
let create_list_assoc ic f =
  let rec append_list_assoc ic f l =
    match next_line ic with
    | None -> l
    | Some line ->
    let pair = pair_of_string line f in
      append_list_assoc ic f (pair :: l)
  in append_list_assoc ic f []

(** Parse rules of a lsystem form an input channel *)
let parse_rules ic =
  let assoc = create_list_assoc ic word_of_string in
  create_match_function assoc (fun (x: char) -> Symb x)

(** Parse interp function of a lsystem form an input channel *)
let parse_interp ic =
  let assoc = create_list_assoc ic command_list_of_string in
  create_match_function assoc (fun x -> raise (Invalid_argument "bad pattern"))

(** Parse a lsystem from a .sys file *)
let parse_system file =
  let ic = open_in file in
  let axiom = parse_axiom ic in
  let rules = parse_rules ic in
  let interp = parse_interp ic in
  {axiom = axiom; rules = rules; interp = interp}
