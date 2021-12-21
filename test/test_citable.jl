@testset "Test `CitableTrait`"  begin
 # Test these in docstrings
 #=
    struct MyOwnUrn <: Urn
        urn::AbstractString
    end
    struct MyOwnCite <: Citable
        urn::MyOwnUrn
        label::AbstractString
    end

    u = MyOwnUrn("urn:fake:id.subid")
    citablething = MyOwnCite(u, "Some citable resource")
    @test citableobject(citablething)


   
    
    import CitableBase: label
    function label(c::MyOwnCite)
        c.label
    end
    import CitableBase: urn
    function urn(c::MyOwnCite)
        c.urn
    end

    @test label(citablething) == "Some citable resource"
    @test urn(citablething) == MyOwnUrn("urn:fake:id.subid")
    =#
end