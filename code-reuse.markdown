---
title: Functional Programming
author: Dougal Stanton
date: October 2013
---


# Overview

## Some Haskell code

But not much

## Recycling

<img src="images/recycle.png" style="border: none;" />

## Map

<img src="images/map.jpg" style="border: none;" />

## Fold

<img src="images/fold.jpg" style="border: none;" />

## Bind

<img src="images/bind.jpg" style="border: none;" />


# Language Notes

## Haskell is...

> ...a polymorphically statically typed, [lazy](#laziness), [purely
> functional](#purity) language...

## Data

`````haskell
data Contact = Email String | Telephone String
`````

## Polymorphic Data

`````haskell
-- unbalanced binary tree
data Tree a = Leaf a 
            | Branch (Tree a) (Tree a)
`````

## Function Definition

`````haskell
square x = x*x
`````

## Function Application

`````haskell
nine = square 3
`````

## Fun & Profit

Haskell in the Browser: <http://tryhaskell.org>

Installation: <http://www.haskell.org/platform>

# Code Reuse


## Data? Yes.

`````c
struct point
{
    double x, y;
};
`````

## Procedures? Yes.

`````c
double distance(struct point * p1, struct point * p2)
{
    return sqrt(pow(p2->x - p1->x,2.0) + pow(p2->y - p1->y,2.0));
}
`````

## Control? No.

`````c
summary * login_details = lookup_username(name);
if (!login_details)
    return ERR_BAD_USER;

profile * user = validate_password(pass, login_details);
if (!user)
    return ERR_BAD_PASS;
`````

## Problems

*   repetition
*   hides intent
*   chance of mistakes

## Foreshadowing

# The FOR loop

##

`````c
for (unsigned int i = 0; i < SIZE; i++)
    numbers[i]++;
`````

What needs fixed here?

## Abstract

*   Remove index `i`
*   Access single array element

##

`````cpp
for (int& v : numbers)
    v++;
`````

Now in C++11.

## 

`````haskell
map (+1) numbers
`````

## Just a function

`````haskell
map f []     = []
map f (x:xs) = f x : map f xs
`````

## Higher Order Function

<img src="images/hoff.jpg" style="border: none;" />

## Why MAP?

Guarantees:

*   1 input = 1 output
*   order of execution is unimportant
*   no dependencies, no history
*   easy to make parallel

## Pixar One-Liner

`````haskell
renderMovie = parmap render movieScenes
`````

# From MAP to FOLD

## Frankie Says

## Relax Those Constraints

`````c
int sum = 0;
for (unsigned int i = 0; i++; i < SIZE)
    sum = sum + numbers[i];
`````

## What Changed?

`````c
int sum = 0;                            // accumulator
for (unsigned int i = 0; i++; i < SIZE)
    sum = sum + numbers[i];             // join with accumulator
`````

## Fold

`````haskell
sum = fold (+) 0 numbers
`````

* * *

Also seen in...

`````haskell
product = fold (*) 1 numbers

largest = fold max 0 numbers

all_true = fold (&&) True booleans
`````

## Why FOLD?

*   Abstract "reduction" technique
*   Strictly more powerful than `map`

## (Just another function)

`````haskell
fold f z []     = z
fold f z (x:xs) = f x (fold f z xs)
`````

# What about Pixar?

##

<img src="images/pixar.jpg" style="border: none;" />

## [5, 2, 3]

$$ 5 + (2 + 3) = (5 + 2) + 3 $$

. . .

$$ 5 - (2 - 3) \neq (5 - 2) - 3 $$

## (Hint: associativity)

$$ x \otimes (y \otimes z) = (x \otimes y) \otimes z $$

## Parallel fold

<img src="images/sumtree.svg" style="border: none;" />

## Google MapReduce

Parallel fold for processing web documents

# Sequencing

## X then Y then Z

Sometimes you want to enforce the order of events

## X maybe Y maybe Z

Sometimes you want to bail out early

## Error conditions

This might be familiar

`````c
summary * login_details = lookup_username(name);
if (!login_details)
    return ERR_BAD_USER;

profile * user = validate_password(pass, login_details);
if (!user)
    return ERR_BAD_PASS;
`````

## Single computation

`````c
summary * login_details = lookup_username(name);
if (!login_details)
{
    return ERR_BAD_USER;
}
`````

## Define your types!

`````haskell
-- Contains an arbitrary result or an error code.
data MaybeNot a    = Error Int | Result a
`````

* * *

`````haskell
data MaybeNot a   =  Error Int | Result a

lookup_username   :: Username -> MaybeNot UserSummary

validate_password :: Password -> UserSummary -> MaybeNot Profile
`````

## Bind: `>>=`

`````haskell
data MaybeNot a    = Error Int | Result a

input >>= function = case input of
                          (Error  e) -> Error e
                          (Result r) -> function r
`````

* * *

`````haskell
lookup_username name >>= validate_password pass
`````
. . .

substituting for the definition of `>>=`

`````haskell
input >>= function = case input of
                          (Error  e) -> Error e
                          (Result r) -> function r
`````

. . .

expands to...

`````haskell
case lookup_username name of
    (Error  e) -> Error e
    (Result r) -> validate_password pass r
`````

## Programmable Semicolon

*   User-defined "sequencing"
*   Different sequence for different types
*   Checked by the compiler every time

# Reusable Control Flow


## Summary

*   `map`, parallelisable `for` loop
*   `fold`, data reduction
*   `bind`, the programmable semicolon

## Reusable Control Flow

. . .

It's the future

. . .

Your language probably can't do it.

. . .

Why not?

# ?

## Laziness

Execution "outside first" instead of "inside first".

`````c
/* C has strict evaluation */
int zero (int n)
{
    return 0;
}

int result = zero (5/0); /* Error! Divide by zero! */
`````

`````haskell
-- Haskell has lazy evaluation
zero n = 0

result = zero (5/0) -- returns 0
`````

## Purity

*   Mathematical functions: $$ f : X \to Y $$
*   Output depends only on input
*   No global variables
*   No mutable state
*   Impure I/O not possible from pure functions
