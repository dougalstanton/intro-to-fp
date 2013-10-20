> {-# LANGUAGE NoMonomorphismRestriction #-}
> 
> import Diagrams.Prelude
> import Diagrams.Backend.SVG.CmdLine

We make use of a tree layout module from the `diagrams-contrib` package:

> import Diagrams.TwoD.Layout.Tree

> numbers = map leaf [2, 5, 4, 3, 6, 5, 8, 7]

Apply a function to a list element and its neighbour, two by two. 

> adjMap f [x,y]    = [f x y]
> adjMap f (x:y:zs) = f x y : adjMap f zs

> sumTree :: [BTree Integer] -> BTree Integer
> sumTree [x] = x
> sumTree xs  = sumTree $ adjMap addTrees xs

> addTrees xt@(BNode x _ _) yt@(BNode y _ _) = BNode (x+y) xt yt

Lay out the tree and render it by providing a function to render nodes
and a function to render edges.

Each parent node is below its children when layed out, so we provide
a negative y-separation to `uniqueXLayout`.

> Just t = uniqueXLayout 2 (-3) (sumTree numbers)
>       
> example = pad 1.1 . lw 3 . centerXY . scale 100
>         $ renderTree
>             (\n -> (text (show n) # fc black
>                     <> rect 3 1.3 # bg white)
>             )
>             (~~) t

> main = defaultMain example
