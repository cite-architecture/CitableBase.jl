# CitableBase.jl

A Julia module defining the two core abstractions of the CITE architecture:

1. identifiers expressible using the syntax of the IETF URN specification
2. citable units, identified by URN, and including a human-readable label


## Implementations of the `Urn` abstraction

The CITE Architecture identifies only two kinds of fundamental URN.  They are implemented in Julia by:

- the `CtsUrn` type, in [CitableText.jl](https://github.com/cite-architecture/CitableText.jl)
- the `Cite2Urn` type, in [CitableObject.jl](https://github.com/cite-architecture/CitableObject.jl)



## Implementations of the `Citable` abstraction


Links will be added to the list below as implementations are tested against the current version of `CitableBase`.


### Citable texts

In the `CitableCorpus` module:
    - `CitablePassage`
    - `CitableDocment`

- citable physical text

Analyses of texts:

- citable analyzed token



### Collections of objects

- citable object



