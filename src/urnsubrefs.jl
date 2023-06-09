#=
subref
hassubref
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
