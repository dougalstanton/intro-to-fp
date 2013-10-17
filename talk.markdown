% Functional Programming in an Independent Scotland
% Dougal Stanton <feedback@dougalstanton.net>
% October 2013

This talk is partially a response to Rob's recent presentation about Python and Lua. Today I will be talking about programming with Haskell, which is the opposite in nearly every way to those languages.

# Reduce - Reuse - Recycle

The message I want to convey today is about code reuse. Code reuse is good. Most procedural languages look at code reuse on the library level: a collection of procedures to load images or play music files or unzip files. The objects in OO languages are libraries-in-the-small: data and methods which operate on them.

I am going to talk about writing code which can be reused at all the other levels. I am going to talk about reusing control flow.

# What is functional programming?

Haskell is a pure functional programming language and development in Haskell is quite different from writing code in C-style languages.

All functions are "pure": they can only produce output dependent on the input. They cannot change state or perform I/O. In fact data is immutable: functions produce new values rather than changing the values passed in.

Procedural code treats a small set of primitives as "first-class citizens"; object-oriented languages treat objects as first-class citizens; functional programming languages treat functions as first class citizens. Functions can be passed to other functions, stored in data structures and returned as results.

Haskell keeps a strict division between pure functions and impure "actions" which can affect the system. This division is enforced by the type system.

# What does Haskell look like?

Haskell inherits a lot from mathematical notation. The names are declared on the left of the equals sign and their definitions appear on the right. Functions and values are declared in the same way, with the functions' parameters also being named on the left. Optionally, each function or constant will have a type signature: the declared name, two colons and the type declaration.

Functions are applied to their argument with just a space (no need for parentheses unless precedence requires it). Function composition is an important idiom: a new function is created by composing two existing functions using the "dot" operation --- this creates a pipeline of functions that data is passed through.

Data structures are declared with `data` keyword for new structures or `newtype` to create a new type isomorphic to an old one. (There is also the `type` keyword for type synonyms as found in C etc.)

Comments begin with two hyphens and continue until the end of the line.

# No more FOR loops

Let's talk about some simple code.

When was the last time you wrote a FOR loop? In C and C++ you need them all the time. Even the simplest FOR loop can have awkward little problems. Starting at the beginning and going to the end of an array is such a simple thing! But we write FOR loops so often that there will inevitably be mistakes.

Why not just write FOR loops once? This is a common idea and has made it into many recent languages --- even C++, in fact. It is often called `foreach`. The functional language equivalent is typically called `map`. 

The sad fact is that a lot of languages don't let you add it yourself because you can't define and use your own control flows. The Haskell implementation is very straightforward though. The definition of `map` takes a function and a list. Each element in the list is transformed by the function. A new list is returned.

## Strings in Lists

The function `length` counts how many characters there are in a string. We can apply it to a single string, but we can just as easily apply it to a whole list of strings. We do that by passing `length` to another function, which does the looping part. A function which operates on other functions is called a "higher order function" and `map` is one of the simplest of many:


The `map` applies `length` to each element of the list in turn. When it gets to the end of the list it stops; we don't need to worry about running off the end (or stopping one short).

(Another way of thinking about `map` is that instead of stepping over each element in the list and converting it, it changes `length`. Where previously `length :: String -> Int` the new function is `map length :: [String] -> [Int]`. This is called "lifting", if you're interested.)

## Strings in Trees

But it doesn't have to operate on lists --- it can also step through trees. The function `map` doesn't really mind what shape of structure it is stepping through.

    
(This time the function `map length :: Tree String -> Tree Int`.)

## Strings sometimes Absent

Sometimes you are dealing with data that might not be there --- in C this is normally handled with a `NULL` pointer. Checking that this data exists is necessary but tedious and easy to forget. But `map` deals with this too, operating on collections of zero-or-one elements.

    
(Here we've lifted to `map length :: Maybe String -> Maybe Int`.)

Or you might have one of two types of data but you only want to process one type and leave the other one as it is. Again `map` is the over-arching abstraction.

## Some strings, not Others

    
(Again, `map length :: Either String String -> Either String Int`.)

This is just one simple way that we can really reuse code. Not only does `length` never have to be rewritten (obviously) but neither does the code to loop over a list or a tree or any other shape containing data.

# Advanced FOR loops

Where next? The world is not simply changing lists of A into lists of B.  I don't want to beat this point to death but we'll cover one more point: collecting together lots of data into a single value.


Or maybe we want to multiply all the values?

You can see there's a lot of repetition there. And lots of basic tasks follow this pattern --- getting the largest or smallest value out of a collection; checking if all booleans are TRUE, or if any are TRUE; concatenating strings; finding the first value above a threshold; and
so on.

Oh, we'll just do it once and for all --- fold all the values together:

    
Actually, this already seems like a lot of work having to remember which number goes with multiply and which number goes with add when starting off. We should abstract that away too.


Rather than remembering which operations and empty values go together to perform which calculations we can create some common abstractions, and tell the compiler we expect it to fold over values of that type.
Maybe we should avoid having to write all that stuff on the left out?

    
Other things which "join together" in some abstract sense:

    
Not only have abstracted over the act of running over a list and joining values together, we can now abstract over how to join together individual data elements, including what to do if the list is empty.

(It goes without saying that we can also use this mechanism to traverse over other data structures, collapsing trees down etc.)

Oh did I mention that the `map` function we used above is a special case of the `fold` function here. Fold takes a list and converts it into a single object, which could in fact be a list.


You can also implement `filter` in the same way:



This has all been a prelude. Time to start getting ambitious. So far everything has been quite linear. The list is the very archetype of linearity and is quite a concrete version of a loop. It's a sort of loop "made real". What are called `union` types in C are concrete if-then-else statements. You can go down one branch but not both; you can store data as one field but not both. Each of these data structures are a concrete version of some control mechanism or process --- the linear sequence, the alternate branch, etc. (Try and work out what others might be.)

If we consider that data structures are control-flow made concrete, what happens we start placing data structures inside data structures? I showed you earlier an optional type which can contain a single value or nothing, which I likened to a pointer which may be `NULL`. If the optional type contains another optional type, then either of them could be nothing:

    
In the C style we'd perform an action, get a (possibly failing) result, perform another action on that, and so on. At each point we have to repeat the error-checking.

    
Honestly this process of repeating the checks is quite tedious. You can see that if we ever get a `Nothing` we can't go any further. We want to write this check once, and only process the next value if it exists. So let's do that!

    
Or

    
If the user doesn't exist then no password can be returned; if no password is on record then we can't get access to the user's profile. All the checking is done for us within the definition of `>>=` (bind).

Earlier I also showed a data structure which is like a `union` which can contain one of two types but not both (and not neither). If we allow nesting of one these types inside another:

    
Like the previous case, nested `union`s represent processes which can fail but this time we can tell which step failed. Nested unions are concrete versions of computations that fail with error messages.

So let's replace the definitions of the functions that produce errors. The manual process looks like this:

    
This is basically identical to what we wrote above. The errors are returned unchanged and the correct values are processed further. Can't we just use the same code as above? Yes.

    
What we're doing here is sequencing functions, but using a custom sequencing algorithm. It's as if we've taken the semicolon that we use all the time in C and said "every time you see a semicolon, carry out some extra work --- if the previous computation failed then just exit early.

This notion of "programmable semicolon" is very powerful. We've looked at computations that have success or failure. We can also compute with multiple successes --- non-deterministic computations that can produce many valid answers but we can work with all of them simultaneously as if there were only one value.

The power of all this is that *none of it is baked in*. This is all code that the user can write or import from libraries that other users have written. There is no particular language construct within the specification that requires this. You can define your own data structures and define how you want to map over them, how you want to string them together and so on.

The power inherent in this approach is slowly trickling down into other languages. Programmers using LINQ on the .NET platform are using a simplified version of this, optimised for querying and aggregating data;



and also "workflows" in F#. Parsers written in this style are very flexible and user-friendly and now exist for a wide selection of languages, including even C++ (ugly though it may be).
