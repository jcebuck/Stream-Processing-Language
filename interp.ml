open Eval

let _ = 
	let line = input_line stdin in
	let number_streams = int_of_string line in

	let line = input_line stdin in
	Eval.stream_length := int_of_string line;
	for i = 1 to number_streams do
		let line = input_line stdin in
		Eval.populate_stream line i ;
	done;

	let program_file = open_in Sys.argv.(1) in
	let lexbuf = Lexing.from_channel program_file in
	try
		let result = Parser.main Lexer.main lexbuf in
		eval result ; Eval.print_output 1; flush stdout ;
		close_in program_file
	with
		| Parsing.Parse_error -> prerr_string "Syntax Error. Please check your syntax."
		| Eval.Out_of_bounds -> prerr_string "Stream number does not exist."
		| Eval.Unset_var -> prerr_string "Access to an undefined variable."
	;
	print_newline (); flush stderr
