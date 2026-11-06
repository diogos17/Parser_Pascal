{
module Lexer where
}

%wrapper "basic"

$alpha = [a-zA-Z_]
$digit = [0-9]

tokens :-
  $white+                          ;  --ignorar caracteres brancos

  "program"                        { \_ -> T_PROGRAM  }
  "var"                            { \_ -> T_VAR }
  "begin"                          { \_ -> T_BEGIN }
  "end"                            { \_ -> T_END }
  "if"                             { \_ -> T_IF }
  "then"                           { \_ -> T_THEN }
  "else"                           { \_ -> T_ELSE }
  "while"                          { \_ -> T_WHILE }
  "do"                             { \_ -> T_DO }
  "not"                            { \_ -> T_NOT }
  "and"                            { \_ -> T_AND }
  "or"                             { \_ -> T_OR }
  "div"                            { \_ -> T_DIV }
  "mod"                            { \_ -> T_MOD }
  "integer"                        { \_ -> T_INTEGER }
  "real"                           { \_ -> T_REAL }
  "string"                         { \_ -> T_STRING }
  "boolean"                        { \_ -> T_BOOLEAN }
  "true"                           { \_ -> T_BOOL True }
  "false"                          { \_ -> T_BOOL False } -- perguntar questao das uppercase letters
  "write" | "writeln"              { \s -> T_WRITE s }
  "read"  | "readln"               { \s -> T_READ s }
  ":="                             { \_ -> T_ASSIGN }
  "<=" | ">=" | "<>" | "=" | "<" | ">"  { \s -> T_COMPARATOR s }
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