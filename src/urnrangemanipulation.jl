"""True if `u` is a range-type URN.
$(SIGNATURES)
"""
function isrange(u::T)::Bool where T <: Urn
    string(u) |> str_isrange
end

"""True if `s` has a range pattern.
$(SIGNATURES)
"""
function str_isrange(s::AbstractString)::Bool 
    if isempty(s)
        false

    elseif s[1] == '-'
        throw(ArgumentError("Invalid object identifer `$(s)`.  Range parts may not be empty."))
    end
    rangeparts = split(s,"-")
    if length(rangeparts) == 2
        if isempty(rangeparts[1]) || isempty(rangeparts[2])
            throw(ArgumentError("Invalid URN `$(s)`.  Range parts may not be empty."))
        else
            true
        end
    elseif length(rangeparts) > 2
        throw(ArgumentError("Invalid URN `$(s)`.  Too many hyphen-delimited parts."))

    else
        false
    end
end

"""
$(SIGNATURES)
Extract first part from a range expression in URN `u`.
"""
function range_begin(u::T)::AbstractString where T <: Urn
    components(u)[end] |> str_range_begin
end


"""
$(SIGNATURES)
Extract second part from a range expression in URN `u`.
"""
function range_end(u::T)::AbstractString where T <: Urn
    components(u)[end] |> str_range_end
end

"""
$(SIGNATURES)
Extract first part from a range expression in `s`.
"""
function str_range_begin(s::AbstractString)::AbstractString
    if str_isrange(s)
        rangeparts = split(s,"-")
        rangeparts[1]
    else
        throw(ArgumentError("$(s) is not a range."))
    end
end

"""
$(SIGNATURES)
Extract second part from a range expression.
"""
function str_range_end(s::AbstractString)::AbstractString
    if str_isrange(s)
        rangeparts = split(s,"-")
        rangeparts[2]
    else
        throw(ArgumentError("$(s) is not a range."))
    end
end