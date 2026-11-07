{
module Lexer where
}

%wrapper "basic"

$alpha = [a-zA-Z_]
$digit = [0-9]

tokens :-
  $white+;                   --ignorar caracteres brancos
  "//".*  ;                  -- qualquer linha iniciada por // com 0 ou mais carateres (\n não incluido .)
  \{ ([^\}] | \n)* \} ;           -- qualquer conjunto de 0 ou mais caraters exceto } delimitado por {}
  
  [pP][rR][oO][gG][rR][aA][mM]      { \_ -> T_PROGRAM  }
  [vV][aA][rR]                     { \_ -> T_VAR }
  [bB][eE][gG][iI][nN]             { \_ -> T_BEGIN }
  [eE][nN][dD]                     { \_ -> T_END }
  [iI][fF]                         { \_ -> T_IF }
  [tT][hH][eE][nN]                 { \_ -> T_THEN }
  [eE][lL][sS][eE]                 { \_ -> T_ELSE }
  [wW][hH][iI][lL][eE]             { \_ -> T_WHILE }
  [dD][oO]                         { \_ -> T_DO }
  [nN][oO][tT]                     { \_ -> T_NOT }
  [aA][nN][dD]                     { \_ -> T_AND }
  [oO][rR]                         { \_ -> T_OR }
  [dD][iI][vV]                     { \_ -> T_DIV }
  [mM][oO][dD]                     { \_ -> T_MOD }
  [iI][nN][tT][eE][gG][eE][rR]     { \_ -> T_INTEGER }
  [rR][eE][aA][lL]                 { \_ -> T_REAL }
  [sS][tT][rR][iI][nN][gG]         { \_ -> T_STRING }
  [bB][oO][oO][lL][eE][aA][nN]     { \_ -> T_BOOLEAN }
  [tT][rR][uU][eE]                 { \_ -> T_BOOL True }
  [fF][aA][lL][sS][eE]             { \_ -> T_BOOL False }

  ([wW][rR][iI][tT][eE]) | ([wW][rR][iI][tT][eE][lL][nN])    { \s -> T_WRITE s }
  ([rR][eE][aA][dD]) | ([rR][eE][aA][dD][lL][nN])            { \s -> T_READ s }

  ":="                             { \_ -> T_ASSIGN }
  "<=" | ">=" | "<>" | "=" | "<" | ">"                       { \s -> T_COMPARATOR s }
  "+"                              { \_ -> T_PLUS }
  "-"                              { \_ -> T_MINUS }
  "*"                              { \_ -> T_TIMES }
  "/"                              { \_ -> T_SLASH }
  ":"                              { \_ -> T_COLON }
  ";"                              { \_ -> T_SEMICOLON }
  ","                              { \_ -> T_COMMA }
  "."                              { \_ -> T_DOT }
  "("                              { \_ -> T_LPAREN }
  ")"                              { \_ -> T_RPAREN }

  \' [^\']* \'                     { \s -> T_STRLIT (init (drop 1 s)) }
  $digit+ "." $digit+              { \s -> T_NUMREAL (read s) }
  $digit+                          { \s -> T_NUM (read s) }
  [a-zA-Z] ($alpha | $digit)*        { \s -> T_ID s }

{
data Token
  = T_ID String
  | T_NUM Int
  | T_NUMREAL Double
  | T_STRLIT String
  | T_BOOL Bool
  | T_BEGIN | T_END | T_IF | T_THEN | T_ELSE | T_WHILE | T_DO
  | T_INTEGER | T_REAL | T_STRING | T_BOOLEAN
  | T_COMPARATOR String
  | T_NOT | T_AND | T_OR | T_DIV | T_MOD
  | T_ASSIGN
  | T_PLUS | T_MINUS | T_TIMES | T_SLASH
  | T_VAR | T_PROGRAM
  | T_COLON | T_SEMICOLON | T_COMMA | T_DOT
  | T_LPAREN | T_RPAREN
  | T_WRITE String
  | T_READ String
  deriving (Show, Eq)
}