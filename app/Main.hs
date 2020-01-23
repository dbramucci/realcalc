{-# LANGUAGE TypeApplications #-}
module Main (main) where


import System.Environment (getArgs)
import Text.Trifecta (Result(..), _errDoc, _Success)
import Control.Lens ((^?!))

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

      -- The @Double below avoids Haskell's type defaulting rules for numeric types by telling parseFull that forall a means a ~ Double.
      -- This is safe because we are parsing the same text with the same parser.
      let exprDouble = parseFull @Double text ^?! _Success

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
      print $ _errDoc err
