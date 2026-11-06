module Main where

import System.Exit (exitFailure)
import System.IO (hPutStrLn, stderr)

import Lexer
import Parser
import Check
import Pretty

main :: IO ()
main = do
  src <- getContents
  let ast = parse (alexScanTokens src)  --arvore
  case checkProgram ast of
    []   -> putStr (printProgram ast) -- se nao der erros da print à arvore
    errs -> do
      mapM_ (hPutStrLn stderr . ("Erro: " ++)) errs -- se tiver erros imprime-os
      exitFailure
