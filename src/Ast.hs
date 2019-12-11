module Ast where

import Data.Ratio

data Ast a =
    Constant a
  | Add (Ast a) (Ast a)
  | Sub (Ast a) (Ast a)
  | Mult (Ast a) (Ast a)
  | Divide (Ast a) (Ast a)
  | Cos (Ast a)
  | Sin (Ast a)
  | Ln (Ast a)
  | Pow (Ast a) (Ast a)
  | Pi
  | E
  deriving ()

class Consts a where
  pi :: a
  e :: a

instance Consts (Ratio a) where
  pi = error "error pi is not Rational"
  e = error "error e is not Rational"

instance Show a => Show (Ast a) where
  show (Constant x) = show x
  show (Add x y) = "(" ++ show x ++ " + " ++ show y ++ ")"
  show (Sub x y) = "(" ++ show x ++ " - " ++ show y ++ ")"
  show (Mult x y) = "(" ++ show x ++ " * " ++ show y ++ ")"
  show (Divide x y) = "(" ++ show x ++ " / " ++ show y ++ ")"
  show (Cos x) = "cos(" ++ show x ++ ")"
  show (Sin x) = "sin(" ++ show x ++ ")"
  show (Ln x) = "ln(" ++ show x ++ ")"
  show (Pow x y) = "(" ++ show x ++ " ^ " ++ show y ++ ")"
  show Pi = "pi"
  show E = "e"

