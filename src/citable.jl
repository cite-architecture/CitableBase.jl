"A citable unit of any kind is identified by a URN and has a human-readable label."
abstract type Citable end

"""Citable content should implement `cex(c::Citable)`.
"""
function cex end

"""Citable content should implement `label(c::Citable)`.
"""
function label end

"""Citable content should implement `urn(c::Citable)::Urn`
"""
function urn end