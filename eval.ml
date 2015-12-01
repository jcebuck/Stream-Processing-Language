type op = Equal | NotEqual | LessThan | MoreThan | EqualLessThan | EqualMoreThan;;
type arop = Plus | Minus | Times | Divide | Modulo | Exponent;;
type bool = Bool of arith * op * arith
and func = NewVar of string * arith | GetVar of string | AddToOutput of arith | GetStream of int * arith | StreamLength
and stmt = Seq of stmt * stmt | If of bool * stmt * stmt | Uif of bool * stmt | For of arith * stmt | ArithExpr of arith
and arith = Int of int | Arith of arith * arop * arith | Func of func;;

exception Out_of_bounds;; exception Unset_var;;


open Hashtbl;;


let variables = Hashtbl.create 20;;
let in_streams = Hashtbl.create 5;;
let stream_length = ref 0;; (*Interpreter sets this value as it reads from stdin*)
let output = ref [];;


let rec str_to_int_list strList = match strList with
  | [] -> []
  | h :: t -> int_of_string h :: str_to_int_list t
;;


let rec populate_stream str n = 
  let temp = Str.split (Str.regexp "[ \t]+") str in
  Hashtbl.replace in_streams n (str_to_int_list temp)
;;


let rec print_output n =
  print_int (List.length !output);
  print_newline ();
  let rec print_list = function
    | [] -> ""
    | h :: t -> (string_of_int h) ^ " " ^ print_list t
  in
  print_string (print_list !output)
;;


let exponent x y = int_of_float ((float x) ** (float y));;


let rec calc x arop y = match arop with
  | Plus -> x + y
  | Minus -> x - y
  | Times -> x * y
  | Divide -> x / y
  | Modulo -> x mod y
  | Exponent -> exponent x y
;;


let rec create_var name var =
  Hashtbl.replace variables name var;
  var
;;


let rec get_var name =
  try Hashtbl.find variables name
  with Not_found -> raise Unset_var
;;


let rec add_out n =
  output := !output @ [n];
  n
;;


let rec get_stream i y =
  if (i < 1) || (i > !stream_length) then raise Out_of_bounds;
  let stream = Hashtbl.find in_streams i in
  List.nth stream y
;;


let rec eval_func func = match func with
  | NewVar (n,v) -> create_var n (eval_arith v)
  | GetVar (n) -> get_var n
  | AddToOutput (n) -> add_out (eval_arith n)
  | GetStream (i, y) -> get_stream i (eval_arith y)
  | StreamLength -> !stream_length


and eval_arith arith = match arith with
  | Arith (t, arop, a) -> calc (eval_arith t) arop (eval_arith a)
  | Int (n) -> n
  | Func (f) -> eval_func f


and eval_bool expr = match expr with
  | Bool (x, op, y) -> 
  let xi = eval_arith x in
  let yi = eval_arith y in
  match op with
    | Equal -> xi = yi
    | NotEqual -> xi != yi
    | LessThan -> xi < yi
    | MoreThan -> xi > yi
    | EqualLessThan -> xi <= yi
    | EqualMoreThan -> xi >= yi
;;


let rec eval_for i expr =
  for j = 1 to (eval_arith i) do
    eval expr;
  done


and eval stmt = match stmt with
  | Seq (f, s) -> eval f; eval s
  | If (b,p,q) -> if eval_bool b then eval p else eval q
  | Uif (c, s) -> if eval_bool c then eval s
  | ArithExpr (a) -> ignore (eval_arith a)
  | For (i, expr) -> eval_for i expr
;;