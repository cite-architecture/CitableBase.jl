
# Julia collections

By defining five functions on your citable collection, you can make them interoperate with dozens of generic Julia functions for working with collections of data.


## What you need to define

Thes are the five functions you want to define:

```@example bigfive
using Base.Iterators
import Base: length
import Base: eltype
import Base: iterate
import Base: filter
import Base.Iterators: reverse
```

In many cases, you can implement these functions with a single line of code.

- `length`: return the number of items in your collection
- `eltype`: return the type of object your collection contains
- `iterate`: you need to implement two required methods, one for an initial state and taking a single parameter for the collection, a second with two parameters, giving the collection and some state information.  If your collection is indexed (e.g., an Array type), your state information might simply be an index value.
- `filter`: you can use `collect` to create an Array on your citable collection and filter the resulting Array.
- `reverse`: similarly, just collect the values of your collection and pass that to `reverse`




##  What you get


Some of the functions this gives you are:

*functions returning iterators*:

- `collect`
- `drop`
- `dropwhile`
- `enumerate`
- `flatten`
- `partition`
- `product`
- `rest`
- `take`
- `takewhile`
- `zip`

*functions returning other kinds of value*:


- `accumulate`
- `all`
- `allunique`
- `any`
- `argmax`
- `argmin`
- `collect`
- `count`
- `extrema`
- `first`
- `in`
- `isempty`
- `map`
- `reduce`
- `foldl`
- `foldr`
- `maximum`
- `map`
- `mapfoldl`
- `mapfoldr`
- `mapreduce`
- `minimum`
- `prod`
- `unique`
- `∌`


