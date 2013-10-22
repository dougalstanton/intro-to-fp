% Functional Programming
% Dougal Stanton <feedback@dougalstanton.net>
% October 2013

Rob recently gave a talk on Python and Lua in which it was mentioned that I did functional programming because I was "weird". And that sounds like a challenge, so let's talk about functional programming!

# Overview

You want to know what I'll be talking about today but I also want to provide an element of mystery so you don't all walk out straight away. The language I'll be using as an example today is Haskell, so I'll show a little bit of that in isolation. I'll be talking about recycling, about maps, about folds and about binds.

# Haskell intro

Haskell is described this way on the Haskell.org website. The important thing to take away from this description is that it is **statically typed**. If you type nonsense then the compiler can reject your code. In fact the compiler has been known to take that to extremes that most people would reject as going "too far".

Let's look at the syntax. First we have the definition of a data type, a union type which can store either an email address or a telephone number, both of which are represented as strings.

The description on the previous slide mentioned polymorphism so let's look at that next. This is the definition of a generic binary tree: the `a` is a _type variable_ which is instantiated with a particular type so we can have trees of integers, trees of strings, trees of contact details and so on.

To operate on data we need functions, which are defined in the mathematical model: on the left is the name of the function and any parameters it takes. To the right of the equiality sign is the implementation --- we get the square of `x` by multiply by itself. Really minimal, no syntactic fuss getting in the way, no semicolons or braces where they're not needed.

Finally we have a variable that contains the result of squaring 3. Again minimal clutter: no parentheses to apply the function to the argument. We don't need to define the type of the variable `nine` --- the compiler can do that on its own because it knows what `square 3` produces.

If you want to play around with Haskell in your own time you can try haskell in the browser or you can download and install a full set of compiler and libraries called the Haskell Platform.

# Reduce - Reuse - Recycle

The main motivation for today is code reuse, because everyone wants it and it applies across all languages. It's something we can all relate to. My definition for code reuse today is --- once I've written it once, can I avoid writing it again?

Defining reusable data structures is easy in most languages. Generic data structures are often slightly harder (Java generics, C++ templates etc) but still reusable once you've got them.

Procedures can also be reused once written --- in fact, that is the purpose of a named procedure. The `distance` procedure relies on several other predefined procedures which can remain black boxes.

When it comes to control flow we must repeat ourselves. This little snippet I've invented ultimately takes a username and a password to authorise the user for a system. But most of the code show is checking to see if each step worked and then conditionally aborting or moving onto the next stage.

The repetition hides what is going on and promotes mistakes. Forgetting to check that a pointer is not null... is a rite of passage for all C programmers. We'll come back to this example later.

# No more FOR loops

Let's look at some really simple code.

With the topic of repetition and reuse in mind, look at this simple code which increments every value in an array called `numbers`. It doesn't do much but there's a lot of code complexity to do it. We've got this superfluous index value `i` which only serves to keep track of where we are in the array.

What we want is access to the actual elements in the array, not a bookmark. Thankfully the new C++ standard allows us to do this --- no more index value, we just get direct access to the current element of the collection we're looking at.

The Haskell equivalent to the FOR loop is called MAP. We talk about mapping a function `(+1)` across the list `numbers`. Unlike the C++ implementation there isn't a requirement for a language change or a compiler update to get MAP. It's just a function (and a very short one too).

Why is MAP interesting? One of its guarantees is that the output only depends on the input. You can see that in the C++ and the Haskell code because you only ever get access to a single element at a time. With a FOR loop in C it would be easy to examine the index and pick up adjacent elements and so on, which MAP prevents from happening. It means we can separate the execution of each step from its neighbours, performing them in any order as necessary. If it's hard work we can perform these computations in parallel since no individual step depends on any other.

If we want we can split off chunks of the input to different machines to be computed in parallel, like rendering a movie out of order and then re-assembling the pieces at the end.

MAP is a function that takes another function as an argument. Such functions are called higher-order functions or HOFs. Defining and using higher-order functions is one of the key features of functional programming.

# Alternative FOR loops

The standard definition of MAP provides these guarantees of "non-interference" but sometimes a bit of interference is useful. Often you want to traverse values in order, remembering what you've seen --- summing values, finding the largest or smallest element and so on.

We often see this idiom with FOR loops where an accumulator value is initialised (to zero, to false) and then we step through each element, comparing the accumulator to the current element in the collection. In the process we don't often change the elements of the collection. We are only interested in the accumulator at the end. In essence what we've done is reduced the collection down to a single value.

## FOLDing

This control flow is often called a FOLD. We fold the whole list down into a single thing. FOLD is another higher-order function like MAP but more interesting. The function it takes as an argument is what we use to select a new value for the accumulator. If we supply an addition function each step produces the sum of the current accumulator and the current element; at the next step result of the previous step is added to the next element. The result at the end of the FOLD operation is a sum of all the values. The only other thing fold needs is the initial value of the accumulator, which for a summation would be zero.

FOLD is an abstraction of many important functions --- MAXIMUM, MINIMUM, SUM, PRODUCT, ANY, ALL.

One of the most interesting things about FOLD is that it's strictly more powerful than MAP. You can implement MAP with FOLD without loss of power. If FOLD reduces a collection to a single value, maybe it helps to think of that single value being another collection? Indeed, it could be the *same* collection. We can also create a map that removes some of the elements, ie FILTER.

## Making FOLDs parallel

What we lost with the ability to drag an accumulator across all our collection is that there is now an execution order and a data dependency. You can't process the second element until the first has been processed, etc.

Well, maybe you can. The largest element in a collection is the same if we start from the left or the right, or if we find the largest from all the odd values and the largest from all the even values and then compare those two.

But subtraction doesn't work. If we start from the left or the right we get different answers. The same happens with division. Anywhere you need parenthese to specify the order of execution is a sign that it matters. Maybe there's something about the properties of these functions? (Associativity, associativity, associativity...)

Given an associative operator we can create lots of mini-FOLDs with their own accumulators, which can be run in parallel and their results FOLDed together and so on until we reach a final answer. A truly parallel fold would have an execution shaped like a tree, joining together from leaf to root.

If this idea is interesting you should look into Fortress, a research language designed for high-performance computing. One of its big ideas was that there would be no linear data and no linear execution so that everything could be parallelised. Sadly it suffered the quick death of most research languages but the ideas are still really exciting.

## Other FOLDs

We've come this far and hopefully there have been some new concepts already. But at the moment all we've discussed is linear data structures: lists and arrays. There are many other shapes of data we can invent. Trees. Option types. Sum types.







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
