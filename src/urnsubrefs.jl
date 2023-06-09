#=
subref

dropsubref

=#

"""True if last component of `u` has a sub-reference.
$(SIGNATURES)
"""
function hassubref(u::T)::Bool where T <: Urn
    components(u)[end] |> str_hassubref
end

"""
$(SIGNATURES)
True if `s` has a subreference pattern.
"""
function str_hassubref(s::AbstractString)::Bool
    # True if either element of a range identifier has a subreference:
    if str_isrange(s)
        str_hassubref(str_range_begin(s)) || str_hassubref(str_range_end(s))
 
    elseif isempty(s)
        false

    elseif s[1] == "@"
        throw(ArgumentError("Invalid URN notation `$(s)`.  Subreference without identifier."))
       
    else
        refparts = split(s,"@")
        partcount = size(refparts,1)
        if partcount ==  1 || partcount == 0
            false

        elseif partcount == 2
            if isempty(refparts[1]) || isempty(refparts[2])
                throw(ArgumentError("Invalid syntax `$(s)`.  Subreference may not be empty."))
            else
                true
            end
        else
            throw(ArgumentError("Invalid passage component `$(s)`.  Too many @-delimited parts."))
        end
    end
end


"""
$(SIGNATURES)
Extract subreference from a a URN, or empty
string if there is no subreference.
"""
function subref(u::T) where T <: Urn
    string(u) |> str_subref
end

"""
$(SIGNATURES)
Extract subreference from a string.
"""
function str_subref(s::AbstractString)
    if str_isrange(s)
        throw(ArgumentError("Invalid subreference syntax `$(s)`.  Subreference can only be extracted from individual components of a range reference."))
    end
    if s[1] == '@'
        throw(ArgumentError("Invalid subreference syntax `$(s)`.  Subreferences may not be attached to empty identifiers."))
    end

    segments = split(s,"@")
    count = length(segments)
    if count == 1
        ""
    elseif count == 2
        segments[2]
    else
        throw(ArgumentError("Invalid subreference syntax `$(s)`.  Too many `@` characters."))
    end
end