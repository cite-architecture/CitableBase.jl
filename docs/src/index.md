# CitableBase

The CitableBase module defines four core abstractions of the CITE architecture:

1. identifiers expressible using the syntax of the IETF URN specification
2. citable units, identified by URN, and including a human-readable label
3. comparison of individual citable units or collections of citable units using URN logic
4. round-trip serialization to and from the plain-text CEX format

The following pages:

1. illustrate how to implement the `Urn` type, the `Citable` type, the `UrnComparisonTrait` and the `CexTrait`
2. list examples of implementations
3. document public functions and types of the `CitableBase` module

