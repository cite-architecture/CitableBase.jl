@testset "Test comparing URN types" begin
    struct UrnThing
            urn::AbstractString
    end
    UrnComparisonTrait(x::UrnThing)  = UrnComparable()
    
    function urncontains(u1::UrnThing, u2::UrnThing)
        startswith(u1.urn, "urn:fake:") && startswith(u2.urn, "urn:fake:")
    end

    function urnsimilar(u1::UrnThing, u2::UrnThing)
        urncontains(u1, u2)
    end

    function urnequals(u1::UrnThing, u2::UrnThing)
        u1.urn == u2.urn
    end

    thing1 = UrnThing("urn:fake:id.subid")
    thing2 = UrnThing("urn:fake:id2")
    @test urnsimilar(thing1, thing2)
    @test urncontains(thing1, thing2)
    @test urnequals(thing1, thing2) == false
end