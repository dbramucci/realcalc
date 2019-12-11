{-# LANGUAGE MultiWayIf #-}
module PrimitiveReal where

-- Sub refers to these reals only ranging from [-1, 1]

newtype SignedDigitRealSub = SignedDigitRS [Int]

newtype DyadicRealSub = DyadicRS [(Integer, Integer)]

type SignedDigitRealSubT = [Int]

type DyadicRealSubT = [(Integer, Integer)]

class Real a where
  add :: a -> a -> a
  sub :: a -> a -> a
  mult :: a -> a -> a

  neg :: a -> a

  average :: a -> a -> a

{-
instance PrimitiveReal.Real SignedDigitRealSub where
  -- Plume pg 40
  neg (SignedDigitRS xs)= SignedDigitRS (fmap negate xs)


  -- Plume 56
  average (SignedDigitRS x) (SignedDigitRS y) = SignedDigitRS $ average' x y 0
    where
      average' (a:xs) (b:ys) c'
        | d' `rem` 2 == 0 = sign d' : average' xs ys 0
        | otherwise       = average'' xs ys d'
        where
          c = c'*2
          d' = a + b + c

      average'' (a:xs) (b:ys) d' = e:average' xs ys c'
        where
          d = 2*d'+a+b
          e = if | 2 < d && d <= 6   -> 1
                 | -2 <= d && d <= 2 -> 0
                 | -6 <= d && d < -2 -> -1

      sign x
        | x < 0  = -1
        | x == 0 = 0
        | otherwise = 1

  mult (SignedDigitRS x) (SignedDigitRS y) = SignedDigitRS $ mult' x y
    where
      mult (a0:a1:x) (b0:b1:y) = average'' p q
        where
          p = average''
                ((a0*b1) : average'' (digit_stream_mult b1 x)
                                      (digit_stream_mult a1 y))

                (average'' (digit_stream_mult b0 x)
                           (digit_stream_mult a0 y))
          q = (a0*b0) : (a1*b0) : (a1*b1) : mult (SignedDigitRS x) (SignedDigitRS y)

          average'' x y = case average (SignedDigitRS x) (SignedDigitRS y) of SignedDigitRS z -> z 
lowestTerm :: (Integer, Integer) -> (Integer, Integer)
lowestTerm (0, _) = (0, 0)
lowestTerm (a, b) | a `rem` 2 /= 0 = (a, b)
lowestTerm (a, b) = lowestTerm (a `div` 2, b - 1)


instance PrimitiveReal.Real DyadicRealSub where
  -- Plume pg 40
  neg (DyadicRS xs) = DyadicRS (fmap (\(a, b) -> (negate a, b)) xs)

  average (DyadicRS xs) (DyadicRS ys) = DyadicRS $ average' xs ys
    where
      average' (a:xs) (b:ys) = (digitAv a b) : average' xs ys
      digitAv (a, b) (c, d) =
        case compare b d of
          LT -> (a+c*2^(b-d), b + 1)
          EQ -> lowestTerm (a + c, b + 1)
          GT -> (a*2^(d-b) + c, d + 1)

  mult (DyadicRS (x:xs)) (DyadicRS (y:ys)) = average p q
    where
      p = DyadicRS $ digit_mult x y : (\(DyadicRS x) -> x) (mult (DyadicRS xs) (DyadicRS ys))
      q = average (DyadicRS (digit_stream_mult y xs)) (DyadicRS (digit_stream_mult x ys))
      -- Plume pg 125
      digit_mult (a, b) (c, d) = (a*c, b+d)
      digit_stream_mult x = fmap (digit_mult x)
-}
