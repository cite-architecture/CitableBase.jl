#=
subref
hassubref
dropsubref

isrange
range_begin
range_end

=#

"""True if `u` is a range-type URN.
$(SIGNATURES)
"""
function isrange(u::T) where T <: Urn
    string(u) |> str_isrange
end

"""True if `s` has a range pattern.
$(SIGNATURES)
"""
function str_isrange(s::AbstractString)
    if isempty(s)
        false

    elseif s[1] == "-"
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
