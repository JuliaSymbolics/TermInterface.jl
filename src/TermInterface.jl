"""
This module defines a contains definitions for common functions that are useful
for symbolic expression manipulation. Its purpose is to provide a shared
interface between various symbolic programming Julia packages.

This is currently borrowed from TermInterface.jl. If you want to use
Metatheory.jl, please use this internal interface, as we are waiting that a
redesign proposal of the interface package will reach consensus. When this
happens, this module will be moved back into a separate package.

See https://github.com/JuliaSymbolics/TermInterface.jl/pull/22
"""
module TermInterface

"""
  istree(x)

Returns `true` if `x` is a term. If true, `operation`, `arguments` and 
`is_function_call` must also be defined for `x` appropriately.
"""
istree(x) = false
export istree


"""
  symtype(x)

Returns the symbolic type of `x`. By default this is just `typeof(x)`.
Define this for your symbolic types if you want `SymbolicUtils.simplify` to apply rules
specific to numbers (such as commutativity of multiplication). Or such
rules that may be implemented in the future.
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
issym(x) = false
export issym


"""
  operation(x)

If `x` is a term as defined by `istree(x)`, `operation(x)` returns the operation of the
term. If `x` represents a function call term like `f(a,b)`, the operation
is the function being called, `f`.
"""
function operation end
export operation


"""
  arguments(x)

Get the arguments of a term `x`, must be defined if `istree(x)` is `true`.
"""
function arguments end
export arguments

"""
  unsorted_arguments(x::T)

If x is a term satisfying `istree(x)` and your term type `T` provides
and optimized implementation for storing the arguments, this function can 
be used to retrieve the arguments when the order of arguments does not matter 
but the speed of the operation does.
"""
unsorted_arguments(x) = arguments(x)
export unsorted_arguments


"""
  arity(x)

Returns the number of arguments of `x`. Implicitly defined 
if `arguments(x)` is defined.
"""
arity(x)::Int = length(arguments(x))
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
function metadata(x, data) end


"""
  maketerm(T::Type, operation, arguments; is_call = true, type=Any, metadata=nothing)

Has to be implemented by the provider of the expression type T.
Returns a term that is in the same closure of types as `T`,
with `operation` as the operation and `arguments` as the arguments, `type` as the symtype
and `metadata` as the metadata. 

`is_call` is used to determine if the constructed term represents a function
call. If `is_call = true`, then it must construct a term `x` such that
`is_function_call(x) = true`, and vice-versa for `is_call = false`.
"""
function maketerm end
export maketerm



"""
  node_count(t)
Count the nodes in a symbolic expression tree satisfying `istree` and `arguments`.
"""
node_count(t) = istree(t) ? reduce(+, node_count(x) for x in arguments(t), init in 0) + 1 : 1
export node_count


end # module

