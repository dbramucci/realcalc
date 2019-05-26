{-# LANGUAGE OverloadedStrings #-}
-- Applicative Do allows haskell to use the
-- Applicative typeclass (which is simpler and often faster)
-- then the more complex Monad typeclass allowing performance boosts
{-# LANGUAGE ApplicativeDo #-}
module Parser where

import Ast (Ast(..))

import Control.Applicative
import Control.Monad (when)

import Text.Trifecta
import qualified Data.Text as T
import Data.Char (isSpace)
import Data.Ratio ((%), Rational)

-- I couldn't find the predefined rational primitive
parseRational :: Parser Rational
{-
parseRational =
  do
    sign <- optional (char '+' <|> char '-')
    pre <- fromIntegral <$> decimal
    post <- option 0 $ (\x -> x % 10^(digits x + 1)) <$> (char '.' *> decimal)
    pure $ case sign of
             Just '+' -> pre + post
             Just '-' -> -(pre + post)
             Nothing  -> pre + post
  where
    digits n =
      if n < 10
        then 0
        else 1 + digits (n `div` 10)
-}
parseRational =
  do
    num <- naturalOrScientific
    pure $ case num of
      Left x -> toRational x
      Right x -> toRational x

term :: Parser (Ast Rational)
term =
  do
    whiteSpace
    parens expression
      <|> Pi <$ symbol "pi"
      <|> E <$ symbol "e"
      <|> Constant <$> parseRational
  <?> "Term"

factor :: Parser (Ast Rational)
factor =
  term `chainl1` multop
  <?> "Factor"
  where
    multop =
      do
        whiteSpace
        Mult <$ char '*' <|> Divide <$ char '/'

expression :: Parser (Ast Rational)
expression =
  factor `chainl1` addop
  <?> "Expression"
  where
    addop = between whiteSpace whiteSpace $
          Add <$ char '+'
      <|> Sub <$ char '-'
parseFull :: String -> Result (Ast Rational)
parseFull = parseString (expression <* eof <?> "full string") mempty
