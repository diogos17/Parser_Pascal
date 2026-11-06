module Pretty (printProgram) where

import AST
import Data.Char (toLower)
import Data.List (intercalate)

-- Arvore generica: um no com texto e filhos
data Tree = Node String [Tree]

render :: Tree -> String
render = unlines . go 0
  where
    go n (Node s cs) = (replicate (2 * n) ' ' ++ s) : concatMap (go (n + 1)) cs

printProgram :: Program -> String
printProgram = render . progTree

progTree :: Program -> Tree
progTree (Program name vars body) =
  Node ("Program" ++ maybe "" (' ' :) name)
    [ Node "Vars" (map varDeclTree vars)
    , Node "Body" (map cmdTree body)
    ]

varDeclTree :: VarDecl -> Tree
varDeclTree (VarDecl ns t) = Node (intercalate ", " ns ++ " : " ++ typeName t) []

typeName :: Type -> String
typeName TInt    = "integer"
typeName TReal   = "real"
typeName TString = "string"
typeName TBool   = "boolean"

-- ===== Comandos =====
cmdTree :: Cmd -> Tree
cmdTree (Assign v e)     = Node ("Assign " ++ v) [numTree e]
cmdTree (AssignBool v e) = Node ("Assign " ++ v) [boolTree e]
cmdTree (Block cs)       = Node "Block" (map cmdTree cs)
cmdTree (If c t me)      = Node "If" ([ Node "Cond" [boolTree c]
                                      , Node "Then" [cmdTree t] ]
                                      ++ maybe [] (\e -> [Node "Else" [cmdTree e]]) me)
cmdTree (While c b)      = Node "While" [Node "Cond" [boolTree c], Node "Do" [cmdTree b]]
cmdTree (Write k as)     = Node (capital k) (map argTree as)
cmdTree (Read k vs)      = Node (capital k) [Node ("Var " ++ v) [] | v <- vs]

argTree :: Arg -> Tree
argTree (ArgNum e)  = numTree e
argTree (ArgBool e) = boolTree e

-- ===== Expressoes booleanas =====
boolTree :: BoolExpr -> Tree
boolTree (Or l r)      = Node "Or"  [boolTree l, boolTree r]
boolTree (And l r)     = Node "And" [boolTree l, boolTree r]
boolTree (Not e)       = Node "Not" [boolTree e]
boolTree (Cmp o l r)   = Node ("Cmp " ++ o) [numTree l, numTree r]
boolTree (BoolLit b)   = Node ("Bool " ++ map toLower (show b)) []

-- ===== Expressoes numericas =====
numTree :: NumExpr -> Tree
numTree (Var v)        = Node ("Var " ++ v) []
numTree (Num n)        = Node ("Num " ++ show n) []
numTree (NumReal d)    = Node ("Real " ++ show d) []
numTree (Str s)        = Node ("Str '" ++ s ++ "'") []
numTree (BinOp o l r)  = Node (opName o) [numTree l, numTree r]
numTree (Neg e)        = Node "Neg" [numTree e]

opName :: Op -> String
opName Add    = "Add"
opName Sub    = "Sub"
opName Mul    = "Mul"
opName Div    = "Div"
opName IntDiv = "IntDiv"
opName Mod    = "Mod"

-- write -> Write, writeln -> Writeln
capital :: String -> String
capital []       = []
capital (c : cs) = (if c >= 'a' && c <= 'z' then toEnum (fromEnum c - 32) else c) : cs
