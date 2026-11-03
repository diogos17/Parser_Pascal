module Main where

import Lexer(alexScanTokens)
import Parser1(parse)

main :: IO ()
main = do
  txt <- getContents -- perguntar ao stor porque que nao da com getContents
  print (parse $ alexScanTokens txt)
