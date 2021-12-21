# CitableBase

The CitableBase module defines two core abstractions of the CITE architecture:

1. *identifiers* expressible using the syntax of the IETF URN specification (the `Urn` abstract type)
2. *citable entities*, identified by URN (the `Citable` abstract type)


Three Julia traits define the essential semantics of these types.

1. the `CitableTrait` requires that citable entities (subtypes of `Citable`) be identified by a URN and have a human-readable label
2. the `UrnComparisonTrait` requires that identifiers (subtypes of `Urn`) *and* citable entities be comparable based on URN *equality*, *containment* and  *similarity*
3.  the `CexSerializable` treat requires that citable entities be losslessly serialized to plain-text representation in CEX format and instantiated from the same plain-text representation

The following pages:

1. illustrate how to implement the `Urn` type and its `UrnComparisonTrait`, the three traits of the `Citable` type, namely, the `CitableTrait`, the `UrnComparisonTrait` and the `CexTrait`
2. list examples of implementations
3. document public functions and types of the `CitableBase` module

