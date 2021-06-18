module TermInterface

"""
    isterm(x)

Returns `true` if `x` is a term. If true, `gethead`, `getargs`
must also be defined for `x` appropriately.
"""
isterm(x) = false
isterm(x::Type{Expr}) = true
export isterm

"""
    symtype(x)

Returns the symbolic type of `x`. By default this is just `typeof(x)`.
"""
function symtype(x)
    typeof(x)
end
export symtype

"""
    issym(x)

Returns `true` if `x` is a symbol. If true, `nameof` must be defined
on `x` and must return a Symbol.
"""
function issym end
export issym

"""
    gethead(x)

If `x` is a term as defined by `isterm(x)`, `gethead(x)` returns the
head of the term if `x` represents a function call, for example, the head
is the function being called.
"""
function gethead end
gethead(e::Expr) = e.head
export gethead

"""
    getargs(x)

Get the arguments of `x`, must be defined if `isterm(x)` is `true`.
"""
getargs(e::Expr) = e.args
export getargs

"""
    arity(x)

Returns the number of arguments of `x`. Implicitly defined 
if `getargs(x)` is defined.
"""
arity(x) = length(getargs(x))
export arity


"""
    metadata(x)

Return the metadata attached to `x`.
"""
metadata(x) = nothing
export metadata


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
and `metadata` as the metadata. By default this will execute `head(args...)`.
`x` parameter can also be a `Type`.
"""
similarterm(x, head, args; type=nothing, metadata=nothing) = head(args...)
similarterm(x::Type{Expr}, head, args; type=nothing, metadata=nothing) = Expr(head, args...)
function similarterm(x::Type{T}, head::T, args; type=nothing, metadata=nothing) where T
    if !isterm(T) head else head(args...) end
end 
export similarterm

end # module

