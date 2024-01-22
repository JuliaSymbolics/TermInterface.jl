module TermInterface

"""
  istree(x)

Returns `true` if `x` is a term. If true, `head` and `children`
must also be defined for `x` appropriately.
"""
istree(x) = false
export istree

"""
  symtype(x)

Returns the symbolic type of `x`. By default this is just `Any`.
Define this for your symbolic types if you want `SymbolicUtils.simplify` to apply rules
specific to numbers (such as commutativity of multiplication). Or such
rules that may be implemented in the future.
"""
symtype(x) = Any
export symtype

"""
  issym(x)

Returns `true` if `x` is a symbol. If true, `nameof` must be defined
on `x` and must return a Symbol.
"""
issym(x) = false
export issym

"""
  head(x)

If `x` is a term as defined by `istree(x)`, `head(x)` returns the head of the
term if `x`. The `head` type has to be provided by the package.
"""
function head end
export head

"""
  children(x)

Get the children of `x`, must be defined if `istree(x)` is `true`.
"""
function children end
export children

"""
  unsorted_children(x::T)

If x is a term satisfying `istree(x)` and your term type `T` provides
and optimized implementation for storing the children, this function can 
be used to retrieve the children when the order of children does not matter 
but the speed of the operation does.
"""
unsorted_children(x) = children(x)
export unsorted_children

"""
  arity(x)

Returns the number of children of `x`. Implicitly defined 
if `children(x)` is defined.
"""
arity(x) = length(children(x))
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
  maketerm(head::H, children; symtype=Any, metadata=nothing)

Has to be implemented by the provider of H.  Returns a term that is in the same
closure of types as `H`, with `head` as the head and `children` as the children,
`symtype` as the symtype and `metadata` as the metadata.
"""
function maketerm end
export maketerm

include("utils.jl")
include("expr.jl")

end # module

