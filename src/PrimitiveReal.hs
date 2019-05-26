module PrimitiveReal where

-- Sub refers to these reals only ranging from [-1, 1]

newtype SignedDigitRealSub = SignedDigitRS [Int]

newtype DyadicRealSub = DyadicRS [(Integer, Integer)]



class Real a where
  add :: a -> a -> a
  sub :: a -> a -> a
  mult :: a -> a -> a

  neg :: a -> a

  average :: a -> a -> a

instance PrimitiveReal.Real SignedDigitRealSub where
  -- Plume pg 40
  neg (SignedDigitRS xs)= SignedDigitRS (fmap negate xs)


lowestTerm :: (Integer, Integer) -> (Integer, Integer)
lowestTerm (0, _) = (0, 0)
lowestTerm (a, b) | a `rem` 2 /= 0 = (a, b)
lowestTerm (a, b) = lowestTerm (a `div` 2, b - 1)


instance PrimitiveReal.Real DyadicRealSub where
  -- Plume pg 40
  neg (DyadicRS xs) = DyadicRS (fmap (\(a, b) -> (negate a, b)) xs)

  average (DyadicRS (a:xs)) (DyadicRS (b:ys)) = DyadicRS $ (digitAv a b) : (\(DyadicRS x) -> x) (average (DyadicRS xs) (DyadicRS ys))
    where
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
