module TermInterface

"""
    isterm(x)

Returns `true` if `x` is a term. If true, `gethead`, `getargs`
must also be defined for `x` appropriately.
"""
isterm(x) = false

"""
    symtype(x)

Returns the symbolic type of `x`. By default this is just `typeof(x)`.
"""
function symtype(x)
    typeof(x)
end

"""
    issym(x)

Returns `true` if `x` is a symbol. If true, `nameof` must be defined
on `x` and must return a Symbol.
"""
function issym end

"""
    gethead(x)

If `x` is a term as defined by `isterm(x)`, `gethead(x)` returns the
head of the term if `x` represents a function call, for example, the head
is the function being called.
"""
function gethead end

"""
    getargs(x)

Get the arguments of `x`, must be defined if `isterm(x)` is `true`.
"""
function getargs end

"""
    metadata(x)

Return the metadata attached to `x`.
"""
metadata(x) = nothing

"""
    metadata(x, md)

Returns a new term which has the structure of `x` but also has
the metadata `md` attached to it.
"""
function metadata(x, data)
    error("Setting metadata on $x is not possible")
end


"""
    similarterm(x, head, args, type; metadata=nothing)

Returns a term that is in the same closure of types as `typeof(x)`,
with `head` as the head and `args` as the arguments, `type` as the symtype
and `metadata` as the metadata. By default this will execute `head(args...)`
"""
similarterm(x, head, args, type; metadata=nothing) = head(args...)

end # module
