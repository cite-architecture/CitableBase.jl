# CitableBase

This package defines traits and abstract types for the essential concepts of the CITE architecture. 

## Essential concepts


### Behaviors of citable resources 

The CITE architecture can be described by four kinds of behavior, corresponding in Julia to four traits or interfaces.


1. *identification*.  Scholarly resources are identified using the syntax of the [IETF URN specification](https://www.ietf.org/rfc/rfc2141.txt), and have a human-readable label.  This is expressed by implementing the `CitableTrait`.
2. *comparison*.  Citable resources can be compared using the URN logic of *equality*, *containment* and  *similarity*.  This is expressed by implementing the  `UrnComparisonTrait`.
3.  *serialization*.  Citable resources can be losslessly serialized to plain-text representation in CEX format and instantiated from the same plain-text representation.  This is expressed by implementing the `CexTrait`.
4. *iteration*. Collections of citable content can be processed sequentially. This is expressed by implementing the iterators interface from Julia's `Iterators` module.



### Abstractions of essential types 

Using these building blocks, the `CitableBase` further defines three core abstractions:

1. an *identifier* uniquely identifies scholarly resources using the syntax of the IETF URN specification. This is represented by the `Urn` abstract type, and requires implementing the `UrnComparisonTrait`.
2. a *citable entity* is a discrete object identified by a URN.  This is represented by the `Citable` abstract type, and requires implementing the `CitableTrait`, `UrnComparisonTrait`, and `CexTrait`.
3. a *citable collection* is a collection of content identifiable by URN.  Unlike identifiers and citable entities, they do not fall within a single type hierarchy, and are not represented by subtyping an abstract type.  Instead, they are identified by the `CitableCollectionTrait`, and implement the `UrnComparisonTrait`, `CexTrait` and `Iterators`.  

!!! tip "An illustration: the CitableCorpus package"

    Some citable collections might additionally implement the `CitableTrait`, in effect making them simultaneously a discrete citable obect (the collection as a whole), and a collection with citable content.  The `CitableCorpus` package illustrates these distinctions handily.  Its `CitablePassage` is a citable object representing a single passage of text.  The `CitableDocument` is both a citable object with its own URN and label, and a collection of citable passages.  The `CitableCorpus` is a pure citable collection of citable documents and citable passages, but does not have its own distinct identifier and label: it is purely a container type.



## Contents of this user's guide

It is perfectly possible to use packages implementing the abstractions of `CitableBase` without understanding how `CitableBase` is designed.  This user's guide is for anyone who needs to build their own custom implementations or simply wishes to understand how these abstractions can be implemented.

The guide works through a hypothetical example to design a reading list of books citable by URN values.  The guide first illustrates how to implement a custom URN type for ISBN-10 numbers. It then creates a custom citable object for books cited by ISBN-10 numbers, and finally defines a custom citable collection representing a reading list.  

Following the user's guide, the documentation includes the formal API documentation for the exported functions and types of the `CitableBase` package.
