{- LANGUAGE NoMonomorphismRestriction -}
module Main where


import System.Environment (getArgs)
import qualified Data.ByteString.Lazy as B
import Text.Trifecta (Result(..))

import Parser
import Compute

type ComputationNum = Rational
type DisplayNum = Double

main :: IO ()
main = do
  (text: _) <- getArgs :: IO [String]
  case id <$> parseFull text of
    Success expr -> do
      putStr "Expr is "
      print expr
      
      
      let Success exprDouble = parseFull text
      let doubleResult = computeAst exprDouble :: Double
      putStr "result when computed as a Double is "
      print doubleResult
      
      
      let result = computeAst expr :: ComputationNum
      putStr "result computed as a Rational is = "
      print result

      -- This is done as a simple way to eliminate the non dis
      let displayResult = fromRational result :: DisplayNum
      putStr "result computed as a Rational and casted to a Double is = "
      print displayResult
      
    Failure err -> do
      putStr "Error when parsing: "
      print err
