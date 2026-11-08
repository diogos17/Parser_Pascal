module Check (checkProgram) where

import AST
    ( NumExpr(Neg, Var, BinOp),
      BoolExpr(..),
      Arg(..),
      Cmd(..),
      Type,
      VarDecl(..),
      Program(..) )
import Control.Monad.Reader
    ( ReaderT(runReaderT), MonadReader(ask) )
import Control.Monad.Writer
    ( MonadWriter(tell), execWriter, Writer )

-- Tabela de simbolos: nome da variavel e o seu tipo
-- (os tipos so serao usados na segunda parte do trabalho)
type SymTab = [(String, Type)]
type CheckM = ReaderT SymTab (Writer[String])  --O readerT passa a informacao da tabela de simbolos no background e o writter accumula possiveis erros na

buildSymTab :: [VarDecl] -> SymTab
buildSymTab vars = [(n, t) | VarDecl ns t <- vars, n <- ns]

-- Devolve a lista de erros (vazia se estiver tudo bem)
checkProgram :: Program -> [String]
checkProgram (Program _ vars body) = execWriter(runReaderT (mapM_ checkCmd body) tab) -- runReaderT injeta tabela de simbolos no ambiente Reader para ser acessivela a qql funcao contida nele
      where tab = buildSymTab vars

checkVar :: String -> CheckM() --validação
checkVar v = do
      tab <- ask --adequirir a tabela do ambiente
      case lookup v tab of  --procura variavel v 
            Just _ -> return () --continua caso esteja na tabela
            Nothing -> tell["Variavel "++ v ++ " nao declarada"] --retorna erro cas

-- ===== Comandos =====
checkCmd :: Cmd-> CheckM ()
checkCmd (Assign v e)     = checkVar v >> checkNum e
checkCmd (AssignBool v e) = checkVar v >> checkBool e
checkCmd (Block cs)       = mapM_ checkCmd cs
checkCmd (If c t me)      = checkBool c >> checkCmd t >> maybe (return ()) checkCmd me
checkCmd (While c b)      = checkBool c >> checkCmd b
checkCmd (Write _ as)     = mapM_ checkArg as
checkCmd (Read _ vs)      = mapM_ checkVar vs

checkArg :: Arg -> CheckM ()
checkArg (ArgNum e)  = checkNum e
checkArg (ArgBool e) = checkBool e

-- ===== Expressões booleanas =====
checkBool :: BoolExpr -> CheckM ()
checkBool (Or l r)    = checkBool l >> checkBool r
checkBool (And l r)   = checkBool l >> checkBool r
checkBool (Not e)     = checkBool e
checkBool (Cmp _ l r) = checkNum l >> checkNum r
checkBool (BoolLit _) = return ()

-- ===== Expressões numéricas =====
checkNum :: NumExpr -> CheckM ()
checkNum (Var v)       = checkVar v
checkNum (BinOp _ l r) = checkNum l >> checkNum r
checkNum (Neg e)       = checkNum e
checkNum _             = return ()