@testset "Test `CexTrait`"  begin
    struct MyOwnUrn <: Urn
        urn::AbstractString
    end
    struct MyOwnCite <: Citable
        urn::MyOwnUrn
        label::AbstractString
    end
    CexTrait(MyOwnCite) = CexSerializable()

    u = MyOwnUrn("urn:fake:id.subid")
    citablething = MyOwnCite(u, "Some citable resource")


    function cex(c::MyOwnCite; delimiter = "|")
        join([c.urn.urn, c.label], delimiter)
    end
    @test cex(citablething) == "urn:fake:id.subid|Some citable resource"


    function fromcex(s::AbstractString, MyOwnCite; delimiter = "|")
        parts = split(s, delimiter)
        MyOwnCite(MyOwnUrn(parts[1]), parts[2])
    end
    rebuilt = fromcex("urn:fake:id.subid|Some citable resource", MyOwnCite)
    @test  rebuilt.label == "Some citable resource"
    @test  rebuilt.urn == MyOwnUrn("urn:fake:id.subid")
end