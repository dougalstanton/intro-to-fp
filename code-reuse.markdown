---
title: Functiona Programming
author: Dougal Stanton
date: October 2013
---

            python --- haskell
         imperative - declarative
    object-oriented - pure functional
      dynamic types - inferred static types
             strict - non-strict ('lazy')
        interpreted - compiled (generally)



$$ f : X \to Y $$

`````haskell
main = putStrLn "Hello, World!"
`````

`````haskell
square n = n*n

pi = 3 -- approximately
`````

`````haskell
length :: String -> Int
`````

    > length "Haskell"
    7

    
        -- changing the contents of a list
    > mylist = ["one", "two", "three"]
    ["one", "two", "three"]

    > map length mylist
    [3, 3, 5]

    
    -- changing the contents of a tree
    > mytree = T "Sun" [T "Earth" [T "Moon"]
                       ,T "Mars"  [T "Phobos",T "Deimos"]]
    ...
    > map length mytree
    ...

    
    -- changing an option if it exists
    > map length Nothing
    Nothing
    > map length (Just "Fishing")
    Just 7

    
    
    -- changing one of two options
    > map length (Left "An error!")
    Left "An error!"
    > map length (Right "Good!")
    Right 5

    
    `````c
int sum = 0;
for (int i = 0; i++; i < SIZE)
    sum = sum + arr[i];
`````


`````c
int product = 1;
for (int i = 0; i++; i < SIZE)
    product = product * arr[i];
`````


> fold (+) 0 [1..10]
    55
    > fold (*) 1 [1..10]
    3628800

    
    | Category| op   | empty |
|---------|------|-------|
| Product | *    | 1     |
| Sum     | +    | 0     |
| Maximum | max  | -inf  |
| Any     | (||) | False |




    > fold (<>) empty (map Product [1..10])
    3628800
    > fold (<>) empty (map Sum [1..10])
    55

    
    > concat (map Product [1..10])
    3628800

    
    -- concatenate strings
    > concat ["one","two","three"]
    "onetwothree"
    -- any values true?
    > concat (map Any [False, False, True, False])
    True
    -- all values true?
    > concat (map All [False, False, True, False])
    False

    
    `````haskell
map f = fold (\x xs -> f x : xs) []
`````

`````haskell
filter p = fold (\x xs -> if p x then x : xs else xs) []
`````

Nothing
    Just Nothing
    Just (Just "Something")

    
    case (lookup_username "bob") of
        Nothing -> Nothing
        Just pw -> case (check_password "secret" pw) of
                        Nothing      -> Nothing
                        Just profile -> Just (get_name profile)

                        
lookup_username "bob" >>= check_password "secret" >>= get_name

do password     <- lookup_username "bob"
       user_profile <- check_password "secret" password
       get_name user_profile

       
       Left "X failed"
    Right (Left "Y failed")
    Right (Right "All succeeded")

    
    case (lookup_username "bob") of
        Left  no_user  -> Left no_user
        Right password -> case (check_password "secret" password) of
                            Left  wrong   -> Left  wrong_password
                            Right profile -> Right (get_name profile)

                            
lookup_username "bob" >>= check_password "secret" >>= get_name

`````cs
var results =
     SomeCollection
     .Where(c => c.SomeProperty < 10)
     .Select(c => new {c.SomeProperty, c.OtherProperty});
`````
<http://en.wikipedia.org/wiki/LINQ>


`````cpp
Parser<string, Tuple2<string, string>>::type single_pair =
    letters >> skip(token_ch('=')) >> letters >> skip_ch(';');
`````

<http://spikebucket.blogspot.com/2007/09/building-maps-with-parsnip.html>

