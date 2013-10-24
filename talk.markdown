% Functional Programming
% Dougal Stanton <feedback@dougalstanton.net>
% October 2013

Rob recently gave a talk on Python and Lua in which it was mentioned that I did functional programming because I was "weird". And that sounds like a challenge, so let's talk about functional programming!

# Overview

You want to know what I'll be talking about today but I also want to provide an element of mystery so you don't all walk out straight away. The language I'll be using as an example today is Haskell, so I'll show a little bit of that in isolation. I'll be talking about recycling, about maps, about folds and about binds.

# Haskell intro

Haskell is described this way on the Haskell.org website.

> ...a polymorphically statically typed, lazy,
> purely functional language...

The important thing to take away from this description is that it is **statically typed**. If you type nonsense then the compiler can reject your code. In fact the compiler has been known to take that to extremes that most people would reject as going "too far".

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

On the larger scale, [Google MapReduce] [mr] is an example of a massively parallel fold --- the name comes from the two higher-order functions MAP and REDUCE (an alternative name for FOLD). This is how they index all the pages that their crawler finds, for example. Thousands of machines process small chunks of the documents discovered and the indices are aggregated together afterwards.

[mr]: <http://research.google.com/archive/mapreduce.html>

# Sequencing

I've concentrated on the benefits to parallelising code that functional programming can provide but sometimes you just want to get things done in series. And sometimes the result of each process depends on whether the previous step was a success. If one step is a failure we abort instead of continuing.

In the motivating section I showed an example of control flow involving looking up usernames and passwords. After the lookup stage we had to check if the username was legitimate before attempting the password validation step.

Let's return to that example and look at the first few lines, where the username lookup may return a user summary or an error. Ideally we should treat this series of statements as a single action with a single outcome --- a type which contains _either_ a result value _or_ an error code. We can define a data type which represents this, encoding the assumptions of the processes explicitly in the type system.

If we rework the procedures we've been using to use this new type where required we can see that the type of the username lookup stage and the password validation stage no longer match up. The type system is pointing out to use where we have to do extra work to show that the result we're taking from `lookup_username` to `validate_password` is correct.

The machinery to deconstruct the type which has been created is basically the same as the IF-THEN-ELSE used by the C-style example except this is enforced by the compiler. But now we can see the machinery needed to deconstruct the type we can create a function to do it for us --- to examine the data and operate on the "success" branch.

The operator we're using to deconstruct the type is called "bind". It lets us pass in a value which may be an error, and only continue the computation if it isn't an error. The outcome is simple to read and "guaranteed" error free in as much as the original code could be error free if properly engineered with all error-checking in place.

In order to demonstrate that this code is equivalent to the longer-winded manual case analysis we can just substitute the definition of BIND in this code and we get the original (manual) definition.

## Programmable Semicolon

The BIND operator allows us to define how we compose functions without adding to the manual packing/unpacking and processing of data. This has been likened to overloading the operation of the semi-colon which separates statements in C-style languages.

# Reusable Control Flow

We've looked at three types of control flow which are common in everyday code but aren't always easy to abstract in mainstream languages --- MAP, FOLD and BIND. These functional idioms are slowly creeping into the mainstream and a lot of languages have "functional tools" libraries which provide limited versions. But in the future they will become more prevalent, either for reasons of succinctness, clarity of expression and understanding, or to allow the language implementations more freedom for optimisation.
