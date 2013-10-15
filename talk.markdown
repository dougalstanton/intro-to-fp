% Functional Programming in an Independent Scotland
% Dougal Stanton <feedback@dougalstanton.net>
% October 2013

This talk is partially a response to Rob's recent presentation about the
languages of Python and Lua. Today I will be talking about programming
with Haskell, which is the opposite in nearly every way to those
languages.

# The basics of FP

Functional programming is ... programming with functions. Or expressions
if you prefer. You all know what a function looks like, a mapping from
input to output.

    in -----> [ function ] -----> out

Functional programming uses only pure functions and immutable data. This
is enforced by the type system but with minimal requirements on the user.
Everything has a known type when compiled but the user often doesn't have
to specify the types: they can be inferred by the compiler.

Expressions are the basic building block. They are first class values;
almost anything that you could do with an `int` in C is possible with a
function. You can store them in data structures, you can partially apply
them, you can pass them as arguments or return them as results. You can
compose them...

# What does Haskell look like?

The traditional introduction looks exactly like you might hope it would.

    main = putStrLn "Hello, World!"

Values are named on the left, and their implementations appear on the
right hand side of the equals sign. It has a mathematical air to it.
Values and functions are defined in the same way:

    square n = n*n

    pi = 3 -- approximately

Function arguments go on the left, and a double-dash starts a comment to
the end of the line. It's all very minimalist and borrows a lot from
mathematical notation. You don't have to supply parentheses when applying
functions to their arguments, for example.

# No more FOR loops

The big win for functional programming is code reuse. I know that's
supposed to be the big idea behind lots of programming but so little of
the code we write is reusable that you would think it wasn't a focus at
all.

When was the last time you wrote a for-loop? In C and C++ you need them
all the time. Why not just write them once? And not just for linear data
either --- if you want to transform the contents of a tree it's
basically the same thing. In fact, any container which holds a value can
be transformed.


## Strings in Lists

Example: The function `length` counts how many characters there are in a
string.

    length :: String -> Int

It works like this:

    > length "Haskell"
    7

We can apply it to a single string, but we can just as easily apply it
to a whole list of strings. We do that by passing `length` to another
function, which does the looping part. A function which operates on
other functions is called a "higher order function" and `map` is one of
the simplest of many:

    -- changing the contents of a list
    > mylist = ["one", "two", "three"]
    ["one", "two", "three"]

    > map length mylist
    [3, 3, 5]

The `map` applies `length` to each element of the list in turn. When it
gets to the end of the list it stops; we don't need to worry about
running off the end (or stopping one short).

(Another way of thinking about `map` is that instead of stepping over
each element in the list and converting it, it changes `length`. Where
previously `length :: String -> Int` the new function is `map length ::
[String] -> [Int]`. This is called "lifting", if you're interested.)

## Strings in Trees

But it doesn't have to operate on lists --- it can also step through
trees. The function `map` doesn't really mind what shape of structure it
is stepping through.

    -- changing the contents of a tree
    > mytree = T "Sun" [T "Earth" [T "Moon"]
                       ,T "Mars"  [T "Phobos",T "Deimos"]]
    ...
    > map length mytree
    ...

(This time the function `map length :: Tree String -> Tree Int`.)

## Strings sometimes Absent

Sometimes you are dealing with data that might not be there --- in C
this is normally handled with a `NULL` pointer. Checking that this data
exists is necessary but tedious and easy to forget. But `map` deals with
this too, operating on collections of zero-or-one elements.

    -- changing an option if it exists
    > map length Nothing
    Nothing
    > map length (Just "Fishing")
    Just 7

(Here we've lifted to `map length :: Maybe String -> Maybe Int`.)

Or you might have one of two types of data but you only want to process
one type and leave the other one as it is. Again `map` is the
over-arching abstraction.

## Some strings, not Others

    -- changing one of two options
    > map length (Left "An error!")
    Left "An error!"
    > map length (Right "Good!")
    Right 5

(Again, `map length :: Either String String -> Either String Int`.)

This is just one simple way that we can really reuse code. Not only does
`length` never have to be rewritten (obviously) but neither does the
code to loop over a list or a tree or any other shape containing data.

# Advanced FOR loops

Where next? The world is not simply changing lists of A into lists of B.
I don't want to beat this point to death but we'll cover one more point:
collecting together lots of data into a single value.

`````c
int sum = 0;
for (int i = 0; i++; i < SIZE)
    sum = sum + arr[i];
`````

Or maybe we want to multiply all the values?

`````c
int product = 1;
for (int i = 0; i++; i < SIZE)
    product = product * arr[i];
`````
You can see there's a lot of repetition there. And lots of basic tasks
follow this pattern --- getting the largest or smallest value out of a
collection; checking if all booleans are TRUE, or if any are TRUE;
concatenating strings; finding the first value above a threshold; and
so on.

Oh, we'll just do it once and for all --- fold all the values together:

    > fold (+) 0 [1..10]
    55
    > fold (*) 1 [1..10]
    3628800

Actually, this already seems like a lot of work having to remember which
number goes with multiply and which number goes with add when starting
off. We should abstract that away too.

| Category| op   | empty |
|---------|------|-------|
| Product | *    | 1     |
| Sum     | +    | 0     |
| Maximum | max  | -inf  |
| Any     | (||) | False |

Rather than remembering which operations and empty values go together to
perform which calculations we can create some common abstractions, and
tell the compiler we expect it to fold over values of that type.

    > fold (<>) empty (map Product [1..10])
    3628800
    > fold (<>) empty (map Sum [1..10])
    55

Maybe we should avoid having to write all that stuff on the left out?

    > concat (map Product [1..10])
    3628800

Other things which "join together" in some abstract sense:

    -- concatenate strings
    > concat ["one","two","three"]
    "onetwothree"
    -- any values true?
    > concat (map Any [False, False, True, False])
    True
    -- all values true?
    > concat (map All [False, False, True, False])
    False

Not only have abstracted over the act of running over a list and joining
values together, we can now abstract over how to join together
individual data elements, including what to do if the list is empty.

(It goes without saying that we can also use this mechanism to traverse
over other data structures, collapsing trees down etc.)

This has all been a prelude. Time to start getting ambitious. So far
everything has been quite linear. The list is the very archetype of
linearity and is quite a concrete version of a loop. It's a sort of loop
"made real". What are called `union` types in C are concrete
if-then-else statements. You can go down one branch but not both; you
can store data as one field but not both. Each of these data structures
are a concrete version of some control mechanism or process --- the
linear sequence, the alternate branch, etc. (Try and work out what
others might be.)

If we consider that data structures are control-flow made concrete, what
happens we start placing data structures inside data structures? I
showed you earlier an optional type which can contain a single value or
nothing, which I likened to a pointer which may be `NULL`. If the
optional type contains another optional type, then either of them could
be nothing:

    Nothing
    Just Nothing
    Just (Just "Something")

In the C style we'd perform an action, get a (possibly failing) result,
perform another action on that, and so on. At each point we have to repeat
the error-checking.

    case (lookup_username "bob") of
        Nothing -> Nothing
        Just pw -> case (check_password "secret" pw) of
                        Nothing      -> Nothing
                        Just profile -> Just (get_name profile)

Honestly this process of repeating the checks is quite tedious. You can
see that if we ever get a `Nothing` we can't go any further. We want to
write this check once, and only process the next value if it exists. So
let's do that!

    lookup_username "bob" >>= check_password "secret" >>= get_name

Or

    do password     <- lookup_username "bob"
       user_profile <- check_password "secret" password
       get_name user_profile

If the user doesn't exist then no password can be returned; if no password
is on record then we can't get access to the user's profile. All the
checking is done for us within the definition of `>>=` (bind).

Earlier I also showed a data structure which is like a `union` which can
contain one of two types but not both (and not neither). If we allow
nesting of one these types inside another:

    Left "X failed"
    Right (Left "Y failed")
    Right (Right "All succeeded")

Like the previous case, nested `union`s represent processes which can fail
but this time we can tell which step failed. Nested unions are concrete
versions of computations that fail with error messages.

So let's replace the definitions of the functions that produce errors. The
manual process looks like this:

    case (lookup_username "bob") of
        Left  no_user  -> Left no_user
        Right password -> case (check_password "secret" password) of
                            Left  wrong   -> Left  wrong_password
                            Right profile -> Right (get_name profile)

This is basically identical to what we wrote above. The errors are
returned unchanged and the correct values are processed further. Can't we
just use the same code as above? Yes.

    lookup_username "bob" >>= check_password "secret" >>= get_name

What we're doing here is sequencing functions, but using a custom
sequencing algorithm. It's as if we've taken the semicolon that we use all
the time in C and said "every time you see a semicolon, carry out some
extra work --- if the previous computation failed then just exit early.

This notion of "programmable semicolon" is very powerful. We've looked at
computations that have success or failure. We can also compute with
multiple successes --- non-deterministic computations that can produce
many valid answers but we can work with all of them simultaneously as if
there were only one value.

The power of all this is that *none of it is baked in*. This is all code
that the user can write or import from libraries that other users have
written. There is no particular language construct within the
specification that requires this. You can define your own data structures
and define how you want to map over them, how you want to string them
together and so on.

The power inherent in this approach is slowly trickling down into other
languages. Programmers using LINQ on the .NET platform are using a
simplified version of this, optimised for querying and aggregating data;

`````cs
var results =
     SomeCollection
     .Where(c => c.SomeProperty < 10)
     .Select(c => new {c.SomeProperty, c.OtherProperty});
`````

<http://en.wikipedia.org/wiki/LINQ>

and also "workflows" in F#. Parsers written in this style are very
flexible and user-friendly and now exist for a wide selection of
languages, including even C++ (ugly though it may be).

`````cpp
Parser<string, Tuple2<string, string>>::type single_pair =
    letters >> skip(token_ch('=')) >> letters >> skip_ch(';');
`````

<http://spikebucket.blogspot.com/2007/09/building-maps-with-parsnip.html>

