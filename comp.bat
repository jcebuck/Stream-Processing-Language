@echo off
ocamlc -c eval.ml
ocamllex lexer.mll
ocamlyacc parser.mly
ocamlc -c parser.mli
ocamlc -c lexer.ml
ocamlc -c parser.ml
ocamlc -c interp.ml
ocamlc -o main.exe str.cma eval.cmo lexer.cmo parser.cmo interp.cmo
del *.cmo *.cmi lexer.ml parser.ml parser.mli