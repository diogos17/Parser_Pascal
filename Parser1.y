{
module Parser1 where
import Lexer
}

%name parse
%tokentype { Token }
%error { parseError }

%token
    -- identificadores e literais
    id          { T_ID $$ }
    num         { T_NUM $$ }
    numreal     { T_NUMREAL $$ }
    strlit      { T_STRLIT $$ }
    boolean_lit { T_BOOL $$ }

    -- estrutura do programa
    "program"   { T_PROGRAM }
    "var"       { T_VAR }
    "begin"     { T_BEGIN }
    "end"       { T_END }

    -- comandos
    "if"        { T_IF }
    "then"      { T_THEN }
    "else"      { T_ELSE }
    "while"     { T_WHILE }
    "do"        { T_DO }
    ":="        { T_ASSIGN }
    write       { T_WRITE $$ }
    read        { T_READ $$ }

    -- tipos
    "integer"   { T_INTEGER }
    "real"      { T_REAL }
    "string"    { T_STRING }
    "boolean"   { T_BOOLEAN }

    -- operadores
    comparator  { T_COMPARATOR $$ }
    "not"       { T_NOT }
    "and"       { T_AND }
    "or"        { T_OR }
    "div"       { T_DIV }
    "mod"       { T_MOD }
    '+'         { T_PLUS }
    '-'         { T_MINUS }
    '*'         { T_TIMES }
    '/'         { T_SLASH }

    -- pontuacao
    ':'         { T_COLON }
    ';'         { T_SEMICOLON }
    ','         { T_COMMA }
    '.'         { T_DOT }
    '('         { T_LPAREN }
    ')'         { T_RPAREN }

-- Precedencias (da MENOR para a MAIOR)
%nonassoc "then"
%nonassoc "else"
%left "or"
%left "and"
%nonassoc comparator
%left '+' '-'
%left '*' '/' "div" "mod"
%right "not"
%nonassoc UMINUS

%%

-- ===== Programa =====
Program : Header VarSection "begin" Cmds "end" '.'   { Program $1 $2 $4 }

Header : {- vazio -}          { Nothing }
       | "program" id ';'     { Just $2 }

VarSection : {- vazio -}      { [] }
           | "var" VarDecls   { $2 }

VarDecls : VarDecl            { [$1] }
         | VarDecls VarDecl   { $1 ++ [$2] }

VarDecl : IdList ':' Type ';' { VarDecl (reverse $1) $3 }

IdList : id                   { [$1] }
       | IdList ',' id        { $3 : $1 }

Type : "integer"             { TInt }
     | "real"                { TReal }
     | "string"              { TString }
     | "boolean"             { TBool }

-- ===== Comandos =====
Cmds : {- vazio -}           { [] }
     | Cmd                   { [$1] }
     | Cmd ';' Cmds          { $1 : $3 }

Cmd : "begin" Cmds "end"                        { Block $2 }
    | "while" boolExpr "do" Cmd                 { While $2 $4 }
    | id ":=" numExpr                           { Assign $1 $3 }
    | id ":=" boolExpr                          { AssignBool $1 $3 }
    | "if" boolExpr "then" Cmd                  { If $2 $4 Nothing }
    | "if" boolExpr "then" Cmd "else" Cmd       { If $2 $4 (Just $6) }
    | write                                     { Write $1 [] }
    | write '(' ')'                             { Write $1 [] }
    | write '(' Args ')'                        { Write $1 (reverse $3) }
    | read '(' IdList ')'                       { Read $1 (reverse $3) }

Args : Arg                   { [$1] }
     | Args ',' Arg          { $3 : $1 }

Arg : numExpr                { ArgNum $1 }
    | boolExpr               { ArgBool $1 }

-- ===== Expressoes booleanas =====
boolExpr : boolExpr "or" boolExpr        { Or $1 $3 }
         | boolExpr "and" boolExpr       { And $1 $3 }
         | numExpr comparator numExpr    { Cmp $2 $1 $3 }
         | "not" boolExpr                { Not $2 }
         | '(' boolExpr ')'              { $2 }
         | boolean_lit                   { BoolLit $1 }

-- ===== Expressoes numericas (e strings) =====
numExpr : id                             { Var $1 }
        | num                            { Num $1 }
        | numreal                        { NumReal $1 }
        | strlit                         { Str $1 }
        | numExpr '+' numExpr            { BinOp Add $1 $3 }
        | numExpr '-' numExpr            { BinOp Sub $1 $3 }
        | numExpr '*' numExpr            { BinOp Mul $1 $3 }
        | numExpr '/' numExpr            { BinOp Div $1 $3 }
        | numExpr "div" numExpr          { BinOp IntDiv $1 $3 }
        | numExpr "mod" numExpr          { BinOp Mod $1 $3 }
        | '-' numExpr %prec UMINUS       { Neg $2 }
        | '(' numExpr ')'                { $2 }

{
-- ===== AST =====
data Program = Program (Maybe String) [VarDecl] [Cmd]
  deriving (Show, Eq)

data VarDecl = VarDecl [String] Type
  deriving (Show, Eq)

data Type = TInt | TReal | TString | TBool
  deriving (Show, Eq)

data Cmd
  = Assign String NumExpr
  | AssignBool String BoolExpr
  | If BoolExpr Cmd (Maybe Cmd)
  | While BoolExpr Cmd
  | Block [Cmd]
  | Write String [Arg]
  | Read String [String]
  deriving (Show, Eq)

data Arg = ArgNum NumExpr | ArgBool BoolExpr
  deriving (Show, Eq)

data BoolExpr
  = Or BoolExpr BoolExpr
  | And BoolExpr BoolExpr
  | Not BoolExpr
  | Cmp String NumExpr NumExpr
  | BoolLit Bool
  deriving (Show, Eq)

data NumExpr
  = Var String
  | Num Int
  | NumReal Double
  | Str String
  | BinOp Op NumExpr NumExpr
  | Neg NumExpr
  deriving (Show, Eq)

data Op = Add | Sub | Mul | Div | IntDiv | Mod
  deriving (Show, Eq)

parseError :: [Token] -> a
parseError toks = error ("Erro de sintaxe perto de: " ++ show (take 3 toks))
}
