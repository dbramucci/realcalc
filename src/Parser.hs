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
parseRational :: Fractional a => Parser a
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
      Left x -> fromRational $ toRational x
      Right x -> fromRational $ toRational x

term :: Fractional a => Parser (Ast a)
term =
  do
    whiteSpace
    parens expression
      <|> Pi <$ symbol "pi"
      <|> E <$ symbol "e"
      <|> Constant <$> parseRational
  <?> "Term"

factor :: Fractional a => Parser (Ast a)
factor =
  term `chainl1` multop
  <?> "Factor"
  where
    multop =
      do
        whiteSpace
        Mult <$ char '*' <|> Divide <$ char '/'

expression :: Fractional a => Parser (Ast a)
expression =
  factor `chainl1` addop
  <?> "Expression"
  where
    addop = between whiteSpace whiteSpace $
          Add <$ char '+'
      <|> Sub <$ char '-'

parseFull :: Fractional a => String -> Result (Ast a)
parseFull = parseString (expression <* eof <?> "full string") mempty
