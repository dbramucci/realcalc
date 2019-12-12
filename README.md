# Real Calc

This is a project in which I implemented a calculator in Haskell.

It uses parse combinators to parse the users input and then evaluates the expression and prints the result.

## Running

Ensure that you have [Stack installed](https://docs.haskellstack.org/en/stable/README/).

Then, to build the project run

```
stack build
```

In the top level directory of this repo.

Then to run it (at present I do not have a resiliant input method yet) run

```
stack run "2 + 3"
```

Replace `2 + 3` with whatever mathematical expression you like that is built only of `+`, `-`, `*`, `/`, and constants.
This will parse your inputs using the standard order of operations, that is `2 + 3 * 4` means the same thing as
`2 + (3 * 4)` and is not read left-to-right as `(2 + 3) * 4`.

Note that Haskell by default uses `%` to mean `2 % 3` is the Ratio 2/3. It will bind tighter than any other option.

## Example Runs

### `stack run "2 + 3"`

```
Expr is (2 % 1 + 3 % 1)
result computed as a Rational is = 5 % 1
result computed as a Rational and casted to a Double is = 5.0
```

### `stack run "(2                    + ((3)))"`

```
Expr is (2 % 1 + 3 % 1)
result computed as a Rational is = 5 % 1
result computed as a Rational and casted to a Double is = 5.0
```

### `stack run "0.000000000000000000001 + 1000000000 - 1000000000"` 

```
Expr is ((1 % 1000000000000000000000 + 1000000000 % 1) - 1000000000 % 1)
result computed as a Rational is = 1 % 1000000000000000000000
result computed as a Rational and casted to a Double is = 1.0e-21
```

Note that this example suffers if done as a double (as seen in GHCi)

```
Prelude> 0.000000000000000000001 + 1000000000 - 1000000000 :: Double
0.0
``` 

### `stack run "2 + 3 * (2/3 - 4/5)"`

```
Expr is (2 % 1 + (3 % 1 * ((2 % 1 / 3 % 1) - (4 % 1 / 5 % 1))))
result computed as a Rational is = 8 % 5
result computed as a Rational and casted to a Double is = 1.6
```

### `stack run "0.3 - 0.2"`

```
Expr is (3 % 10 - 1 % 5)
result computed as a Rational is = 1 % 10
result computed as a Rational and casted to a Double is = 0.1
```

In GHCi to show what would normally happen with this computation.
```
Prelude> 0.3 - 0.2 :: Double
9.999999999999998e-2
```