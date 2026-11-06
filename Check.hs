module Check (checkProgram) where

import AST

-- Tabela de simbolos: nome da variavel e o seu tipo
-- (os tipos so serao usados na segunda parte do trabalho)
type SymTab = [(String, Type)]

buildSymTab :: [VarDecl] -> SymTab
buildSymTab vars = [(n, t) | VarDecl ns t <- vars, n <- ns]

-- Devolve a lista de erros (vazia se estiver tudo bem)
checkProgram :: Program -> [String]
checkProgram (Program _ vars body) = concatMap (checkCmd tab) body
  where tab = buildSymTab vars

checkVar :: SymTab -> String -> [String]
checkVar tab v = case lookup v tab of
  Just _  -> []
  Nothing -> ["variavel '" ++ v ++ "' nao declarada"]

-- ===== Comandos =====
checkCmd :: SymTab -> Cmd -> [String]
checkCmd tab (Assign v e)     = checkVar tab v ++ checkNum tab e
checkCmd tab (AssignBool v e) = checkVar tab v ++ checkBool tab e
checkCmd tab (Block cs)       = concatMap (checkCmd tab) cs
checkCmd tab (If c t me)      = checkBool tab c ++ checkCmd tab t ++ maybe [] (checkCmd tab) me
checkCmd tab (While c b)      = checkBool tab c ++ checkCmd tab b
checkCmd tab (Write _ as)     = concatMap (checkArg tab) as
checkCmd tab (Read _ vs)      = concatMap (checkVar tab) vs

checkArg :: SymTab -> Arg -> [String]
checkArg tab (ArgNum e)  = checkNum tab e
checkArg tab (ArgBool e) = checkBool tab e

-- ===== Expressoes booleanas =====
checkBool :: SymTab -> BoolExpr -> [String]
checkBool tab (Or l r)    = checkBool tab l ++ checkBool tab r
checkBool tab (And l r)   = checkBool tab l ++ checkBool tab r
checkBool tab (Not e)     = checkBool tab e
checkBool tab (Cmp _ l r) = checkNum tab l ++ checkNum tab r
checkBool _   (BoolLit _) = []

-- ===== Expressoes numericas =====
checkNum :: SymTab -> NumExpr -> [String]
checkNum tab (Var v)       = checkVar tab v
checkNum tab (BinOp _ l r) = checkNum tab l ++ checkNum tab r
checkNum tab (Neg e)       = checkNum tab e
checkNum _   _             = []
