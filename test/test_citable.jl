@testset "Test `CitableTrait`"  begin
    struct MyOwnUrn <: Urn
        urn::AbstractString
    end
    struct MyOwnCite <: Citable
        urn::MyOwnUrn
        label::AbstractString
    end
    CitableTrait(x::MyOwnCite) = MyUniquelyCitable()

    u = MyOwnUrn("urn:fake:id.subid")
    citablething = MyOwnCite(u, "Some citable resource")


    function label(c::MyOwnCite)
        c.label
    end
    function urn(c::MyOwnCite)
        c.urn
    end


    @test label(citablething) == "Some citable resource"
    @test urn(citablething) == MyOwnUrn("urn:fake:id.subid")
end