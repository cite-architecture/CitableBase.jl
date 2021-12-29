![build](https://github.com/cite-architecture/CitableBase.jl/actions/workflows/Documentation.yml/badge.svg)


# CitableBase.jl [![version](https://juliahub.com/docs/CitableBase/version.svg)](https://juliahub.com/ui/Packages/CitableBase/6BIMt)

> A Julia module defining core abstractions of the CITE architecture.



**Behaviors**

1. *identification*.  Scholarly resources are identified using the syntax of the [IETF URN specification](https://www.ietf.org/rfc/rfc2141.txt), and have a human-readable label. 
2. *comparison*.  Citable resources can be compared using the URN logic of *equality*, *containment* and  *similarity*.  
3.  *serialization*.  Citable resources can be losslessly serialized to plain-text representation in CEX format and instantiated from the same plain-text representation.
4. *iteration*. Collections of citable content can be processed sequentially

**Abstractions of essential types**

1. an *identifier* uniquely identifies scholarly resources using the syntax of the IETF URN specification. 
2. a *citable entity* is a discrete object identified by a URN. 
3. a *citable collection* is a collection of content identifiable by URN.




**Documentation**

- On line [documentation](https://cite-architecture.github.io/CitableBase.jl/stable/) includes a user's guide that builds a sample project with custom identifiers, citable objects and a citable collection to contstruct a reading list of citable books
- The sample project from the user's guide is also in the `RL` directory of this repository where all the code in the documentation is repeated in unit tests