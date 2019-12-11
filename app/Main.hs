module Main where


import System.Environment (getArgs)
import qualified Data.ByteString.Lazy as B
import Text.Trifecta (Result(..))

import Parser
import Compute

main :: IO ()
main = do
  --[prog, _, text] <- getArgs :: IO [String]
  (text: _) <- getArgs :: IO [String]
  case id <$> parseFull text of
    Success expr -> do
      putStr "Expr is "
      print expr
      let result = computeAst expr :: Rational
      putStr "result = "
      print result
    Failure err -> do
      putStr "Error when parsing: "
      print err
