{
open Parser
exception Eof
}
rule main = parse
    [' ' '\t''\n']+  { main lexbuf }
  | '-'?['0'-'9']+ as num { INT(int_of_string num) }
  | ';' { SEQ }
  | "if" { IF }
  | "then" { THEN }
  | "else" { ELSE }
  | '+' { PLUS }
  | '-' { MIN }
  | '*' { TIMES }
  | '/' { DIV }
  | '%' { MOD }
  | '^' { EXP }
  | "==" { EQUAL }
  | "!=" { EQUALNOT }
  | "<" { LESSTHAN }
  | ">" { MORETHAN }
  | "<=" { EQUALLESSTHAN }
  | ">=" { EQUALMORETHAN }
  | '(' { LPAREN }
  | ')' { RPAREN }
  | '=' { ASSIGN }
  | "for" { FOR }
  | "do" { DO }
  | "endfor" { ENDFOR }
  | "endif" { ENDIF }
  | "write" { WRITE }
  | "get_stream" { GETSTREAM }
  | "stream_length" { LENGTH }
  | '$'['a'-'z''A'-'Z']['a'-'z''A'-'Z''0'-'9']* as str { VAR(str) }
  | eof  { EOF }