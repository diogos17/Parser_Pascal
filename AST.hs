module AST where

--        ======= AST =======
data Program = Program (Maybe String) [VarDecl] [Cmd]
  deriving (Show, Eq)

data VarDecl = VarDecl [String] Type
  deriving (Show, Eq)

data Type = TInt | TReal | TString | TBool
  deriving (Show, Eq)

data Cmd 
    = Assign String NumExpr
    | AssignBool String BoolExpr
    | Block [Cmd]
    | If BoolExpr Cmd (Maybe Cmd)
    | While BoolExpr Cmd
    | Write String [Arg]
    | Read String [String]
    deriving (Show, Eq)

data Arg 
    = ArgNum NumExpr
    | ArgBool BoolExpr 
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
