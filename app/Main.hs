module Main where


import System.Environment (getArgs)
import qualified Data.ByteString.Lazy as B
import Text.Trifecta (Result(..))

import Parser
import Compute

main :: IO ()
main = do
  [prog, text] <- getArgs :: IO [String]
  case id <$> parseFull text of
    Success num -> print num
    Failure err -> print err
