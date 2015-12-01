%{
	open Eval
%}

%token <int> INT
%token <string> VAR
%token LPAREN RPAREN
%token EOF
%token SEQ
%token IF THEN ELSE
%token PLUS MIN TIMES DIV MOD EXP
%token EQUAL EQUALNOT LESSTHAN MORETHAN EQUALLESSTHAN EQUALMORETHAN
%token ASSIGN
%token FOR DO
%token ENDFOR ENDIF
%token WRITE GETSTREAM LENGTH
%token LOVE
%left PLUS MIN
%left TIMES DIV
%left MOD EXP
%nonassoc IF THEN
%nonassoc ELSE
%nonassoc SEQ
%start main
%type <Eval.stmt> main
%%

main : 
	stmt EOF { $1 }
;

stmt :
	| LPAREN stmt RPAREN { $2 }
	| stmt SEQ stmt {Seq ($1, $3) }
	| IF bool THEN stmt ELSE stmt ENDIF { If ($2, $4, $6) }
	| IF bool THEN stmt ENDIF { Uif ($2, $4) }
	| arith { ArithExpr ($1) }
	| FOR arith DO stmt ENDFOR {For ($2, $4)}
;

func:
	| VAR ASSIGN arith {NewVar ($1, $3)}
	| VAR { GetVar ($1) }
	| WRITE arith {AddToOutput ($2)}
	| GETSTREAM INT arith {GetStream ($2, $3)}
	| LENGTH { StreamLength }
;

arith :
	| INT {Int ($1)}
	| func {Func ($1)}
	| arith arop arith {Arith ($1, $2, $3)}
;

arop :
	| PLUS { Plus }
	| MIN { Minus }
	| TIMES { Times }
	| DIV { Divide }
	| MOD { Modulo }
	| EXP { Exponent }
;

bool :
	| arith op arith { Bool ($1, $2, $3) }
;

op :
	| EQUAL { Equal }
	| EQUALNOT { NotEqual }
	| LESSTHAN { LessThan }
	| MORETHAN { MoreThan }
	| EQUALMORETHAN { EqualMoreThan }
	| EQUALLESSTHAN { EqualLessThan }
;