"A citable unit of any kind is identified by a URN and has a human-readable label."
abstract type Citable end

"""Citable content should always be serializable.
"""
function cex end

"""Citable content has a label.
"""
function label end

"""Citable content is identified by a URN.
"""
function urn end