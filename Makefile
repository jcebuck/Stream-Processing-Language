all:
	rm *.cmo *.cmi lexer.ml parser.ml parser.mli -f
	ocamlc -c eval.ml
	ocamllex lexer.mll
	ocamlyacc parser.mly
	ocamlc -c parser.mli
	ocamlc -c lexer.ml
	ocamlc -c parser.ml
	ocamlc -c interp.ml
	ocamlc -o mysplinterpreter str.cma lexer.cmo parser.cmo eval.cmo interp.cmo
	rm *.cmo *.cmi lexer.ml parser.ml parser.mli -f