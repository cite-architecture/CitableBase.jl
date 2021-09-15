var documenterSearchIndex = {"docs":
[{"location":"apis/","page":"API documentation","title":"API documentation","text":"CurrentModule = CitableBase","category":"page"},{"location":"apis/#API-documentation","page":"API documentation","title":"API documentation","text":"","category":"section"},{"location":"apis/#URNs","page":"API documentation","title":"URNs","text":"","category":"section"},{"location":"apis/","page":"API documentation","title":"API documentation","text":"Urn","category":"page"},{"location":"apis/#CitableBase.Urn","page":"API documentation","title":"CitableBase.Urn","text":"Unique identifiers expressible in the syntax of the IETF's URN specification.\n\n\n\n\n\n","category":"type"},{"location":"apis/#Concrete-functions-for-Urns","page":"API documentation","title":"Concrete functions for Urns","text":"","category":"section"},{"location":"apis/","page":"API documentation","title":"API documentation","text":"components\nparts","category":"page"},{"location":"apis/#CitableBase.components","page":"API documentation","title":"CitableBase.components","text":"components(uString)\n\n\nSplits a string on colons (separator for top-level components of URNs).\n\nExamples\n\njulia> components(\"urn:cts:greekLit:tlg0012.tlg001.msA:1.1\")\n\n\n\n\n\ncomponents(u)\n\n\nSplits a URN's string representation into top-level components.\n\n\n\n\n\n","category":"function"},{"location":"apis/#CitableBase.parts","page":"API documentation","title":"CitableBase.parts","text":"parts(componentString)\n\n\nSplits a string on periods (seprator for parts within components of URNs).\n\nExamples\n\njulia> parts(\"tlg0012.tlg001.msA\")\n\n\n\n\n\n","category":"function"},{"location":"apis/#URN-abstractions-to-implement-for-specific-types","page":"API documentation","title":"URN abstractions to implement for specific types","text":"","category":"section"},{"location":"apis/","page":"API documentation","title":"API documentation","text":"addversion\ndropversion\nurncontains\nurnsimilar","category":"page"},{"location":"apis/#CitableBase.addversion","page":"API documentation","title":"CitableBase.addversion","text":"Urn subtypes should implement addversion(urn::U, versionid)::U.  \n\n\n\n\n\n","category":"function"},{"location":"apis/#CitableBase.dropversion","page":"API documentation","title":"CitableBase.dropversion","text":"Urn subtypes should implement dropversion(urn::U)::U.\n\n\n\n\n\n","category":"function"},{"location":"apis/#CitableBase.urncontains","page":"API documentation","title":"CitableBase.urncontains","text":"Urn subtypes should implement urncontains(urn1::U, urn2::U)::Bool\n\n\n\n\n\n","category":"function"},{"location":"apis/#CitableBase.urnsimilar","page":"API documentation","title":"CitableBase.urnsimilar","text":"Urn subtypes should implement urnsimilar(urn1::U, urn2::U)::Bool.\n\n\n\n\n\n","category":"function"},{"location":"apis/#Citable-resources","page":"API documentation","title":"Citable resources","text":"","category":"section"},{"location":"apis/","page":"API documentation","title":"API documentation","text":"Citable","category":"page"},{"location":"apis/#CitableBase.Citable","page":"API documentation","title":"CitableBase.Citable","text":"A citable unit of any kind is identified by a URN and has a human-readable label.\n\n\n\n\n\n","category":"type"},{"location":"apis/#Citable-abstractions-to-implement-for-specific-types","page":"API documentation","title":"Citable abstractions to implement for specific types","text":"","category":"section"},{"location":"apis/","page":"API documentation","title":"API documentation","text":"urn\nlabel\ncex","category":"page"},{"location":"apis/#CitableBase.urn","page":"API documentation","title":"CitableBase.urn","text":"Citable content should implement urn(c::Citable)::Urn\n\n\n\n\n\n","category":"function"},{"location":"apis/#CitableBase.label","page":"API documentation","title":"CitableBase.label","text":"Citable content should implement label(c::Citable).\n\n\n\n\n\n","category":"function"},{"location":"apis/#CitableBase.cex","page":"API documentation","title":"CitableBase.cex","text":"Citable content should implement cex(c::Citable).\n\n\n\n\n\n","category":"function"},{"location":"implementations/#Implementations","page":"Implementations","title":"Implementations","text":"","category":"section"},{"location":"implementations/#Urn","page":"Implementations","title":"Urn","text":"","category":"section"},{"location":"implementations/","page":"Implementations","title":"Implementations","text":"The CITE Architecture identifies only two kinds of fundamental URN.  They are implemented in Julia by:","category":"page"},{"location":"implementations/","page":"Implementations","title":"Implementations","text":"the CtsUrn type, in CitableText.jl\nthe Cite2Urn type, in CitableObject.jl","category":"page"},{"location":"implementations/#Citable","page":"Implementations","title":"Citable","text":"","category":"section"},{"location":"implementations/","page":"Implementations","title":"Implementations","text":"The variety of potential citable resources is open ended.  For a current list of implementations of Citable, see the README for the CitableBase.jl github repository.","category":"page"},{"location":"urns/#URNs:-an-example-implementation","page":"URNs","title":"URNs: an example implementation","text":"","category":"section"},{"location":"urns/","page":"URNs","title":"URNs","text":"The Urn abstract type models a Uniform Resource Name (URN). URNs have a string value with a specified syntax.   Here's a minimal example subtyping the Urn abstraction.","category":"page"},{"location":"urns/","page":"URNs","title":"URNs","text":"using CitableBase\nstruct FakeUrn <: Urn\n    urn::AbstractString\nend\nfake = FakeUrn(\"urn:fake:objectclass.objectid\")\ntypeof(fake) |> supertype\n\n# output\n\nUrn","category":"page"},{"location":"urns/","page":"URNs","title":"URNs","text":"Subtypes of Urn should override the Base definition of print. This makes it possible to use the generic components and parts functions in CitableBase.","category":"page"},{"location":"urns/","page":"URNs","title":"URNs","text":"import Base: print\nfunction print(io::IO, u::FakeUrn)\n    print(io, u.urn)\nend\nprint(fake)\n\n# output\n\nurn:fake:objectclass.objectid","category":"page"},{"location":"urns/","page":"URNs","title":"URNs","text":"Top-level syntactic units are separated by colons: CitableBase refers to these units as components.","category":"page"},{"location":"urns/","page":"URNs","title":"URNs","text":"components(fake)\n\n# output\n\n3-element Vector{SubString{String}}:\n \"urn\"\n \"fake\"\n \"objectclass.objectid\"","category":"page"},{"location":"urns/","page":"URNs","title":"URNs","text":"At a second syntactic level, units are separated by periods.  CitableBase refers to these as parts of a component.","category":"page"},{"location":"urns/","page":"URNs","title":"URNs","text":"components(fake)[3] |> parts\n\n# output\n\n2-element Vector{SubString{String}}:\n \"objectclass\"\n \"objectid\"","category":"page"},{"location":"urns/#URN-manipulation","page":"URNs","title":"URN manipulation","text":"","category":"section"},{"location":"urns/","page":"URNs","title":"URNs","text":"Implementations of the URN interface should  dispatch the following two methods to type-specific functions:","category":"page"},{"location":"urns/","page":"URNs","title":"URNs","text":"dropversion(u::Urn)\naddversion(u::Urn, versionId)","category":"page"},{"location":"urns/#URN-comparison","page":"URNs","title":"URN comparison","text":"","category":"section"},{"location":"urns/","page":"URNs","title":"URNs","text":"Implementations of the URN interface should  dispatch the urncontains(urn1::Urn, urn2::Urn) function and the urnsimilar(urn1::Urn, urn2::Urn) function to type-specific methods.","category":"page"},{"location":"urns/","page":"URNs","title":"URNs","text":"We illustrate the first with a simple-minded function that defines containment as any time the first part of the third component is shared.","category":"page"},{"location":"urns/","page":"URNs","title":"URNs","text":"function urncontains(u1::FakeUrn, u2::FakeUrn)\n    components1 = components(u1)\n    components2 = components(u2)\n\n    parts1 = parts(components1[3])\n    parts2 = parts(components2[3])\n    parts1[1] == parts2[1]\nend\nurn1 = FakeUrn(\"urn:fake:group\")\nurn2 = FakeUrn(\"urn:fake:group.id2\")\nurncontains(urn1, urn2)\n\n# output\n\ntrue","category":"page"},{"location":"urns/","page":"URNs","title":"URNs","text":"Then we define urnsimilar as true if two URNs are equal, or if either contains the other.","category":"page"},{"location":"urns/","page":"URNs","title":"URNs","text":"function urnsimilar(u1::FakeUrn, u2::FakeUrn)\n    urncontains(u1, u2) || urncontains(u2, u1) || u1 == u2\nend\nurnsimilar(urn1, urn2)\n\n# output\n\ntrue","category":"page"},{"location":"#CitableBase","page":"Home","title":"CitableBase","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"The CitableBase module defines two core abstractions of the CITE architecture:","category":"page"},{"location":"","page":"Home","title":"Home","text":"identifiers expressible using the syntax of the IETF URN specification\ncitable units, identified by URN, and including a human-readable label","category":"page"},{"location":"","page":"Home","title":"Home","text":"The following pages:","category":"page"},{"location":"","page":"Home","title":"Home","text":"illustrate how to implement a Urn and a Citable\nlist examples of implementations\ndocument public functions and types of the CitableBase module","category":"page"},{"location":"citable/#Citable-resources:-an-example-implementation","page":"Citable resources","title":"Citable resources: an example implementation","text":"","category":"section"},{"location":"citable/","page":"Citable resources","title":"Citable resources","text":"Citable resources extend the Citable abstract type and  implement three functions: urn, label and cex.   ","category":"page"},{"location":"citable/","page":"Citable resources","title":"Citable resources","text":"using CitableBase\nstruct FakeUrn <: Urn\n    urn::AbstractString\nend\nref = FakeUrn(\"urn:fake:objectclass.objectid\")\n\nstruct FakeCite <: Citable\n    urn::FakeUrn\n    label\nend\ncitable = FakeCite(ref, \"Some citable resource\")\ntypeof(citable) |> supertype\n\n# output\n\nCitable","category":"page"},{"location":"citable/","page":"Citable resources","title":"Citable resources","text":"All citable resources are identified by a Urn, which can be found with the urn function.","category":"page"},{"location":"citable/","page":"Citable resources","title":"Citable resources","text":"function urn(c::FakeCite)\n    c.urn\nend\n\nurn(citable)\n\n# output\n\nFakeUrn(\"urn:fake:objectclass.objectid\")","category":"page"},{"location":"citable/","page":"Citable resources","title":"Citable resources","text":"All citable resources must have a human-readable label.","category":"page"},{"location":"citable/","page":"Citable resources","title":"Citable resources","text":"function label(c::FakeCite)\n    c.label\nend\nlabel(citable)\n\n# output\n\n\"Some citable resource\"","category":"page"},{"location":"citable/","page":"Citable resources","title":"Citable resources","text":"It must be possible to serialize a citable resource following to CiteEXchange format with the cex function.","category":"page"},{"location":"citable/","page":"Citable resources","title":"Citable resources","text":"function cex(c::FakeCite, delimiter = \"#\")\n    join([c.urn.urn, c.label], delimiter)\nend\ncex(citable)\n\n# output\n\n\"urn:fake:objectclass.objectid#Some citable resource\"","category":"page"}]
}
