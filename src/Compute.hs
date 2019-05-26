module Compute where

import Ast

computeAst :: (Consts a, Fractional a) => Ast a -> a
computeAst t =
  case t of
    Constant x -> x
    Add x y -> computeAst x + computeAst y
    Sub x y -> computeAst x - computeAst y
    Mult x y -> computeAst x * computeAst y
    Divide x y -> computeAst x / computeAst y
    Cos x -> error "Not implemented: cos"
    Sin x -> error "Not implemented: sin"
    Ln x -> error "Not implemented: ln"
    Pow x y -> error "Not implemented: pow"
    Pi -> Ast.pi
    E -> e
