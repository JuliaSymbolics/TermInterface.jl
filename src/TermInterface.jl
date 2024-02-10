module TermInterface

"""
    iscall(x)
Returns `true` if `x` is a function call expression. If true, `operation`, `arguments`
must also be defined for `x`.
"""
iscall(x) = false
export iscall

Base.@deprecate_binding istree iscall
"""
   istree(x)

Alias of `iscall`
"""
istree

"""
    isexpr(x)
Returns `true` if `x` is an expression tree (an S-expression). If true, `head` and `children` methods must be defined for `x`.
"""
isexpr(x) = false
export isexpr

"""
    symtype(expr)

Returns the symbolic type of `expr`. By default this is just `typeof(expr)`.
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
    head(x)
Returns the head of the S-expression.
"""
function head end

"""
    children(x)
Returns the children (aka tail) of the S-expression.
"""
function children end

"""
  operation(x)

Returns the function a function call expression is calling.
`iscall(x)` must be true as a precondition.
"""
operation(x) = iscall(x) ? first(children(x)) : error("operation called on a non-function call expression")
export operation

"""
  arguments(x)

Returns the arguments to the function call in a function call expression.
`iscall(x)` must be true as a precondition.
"""
function arguments end
arguments(x) = iscall(x) ? Iterators.drop(children(x), 1) : error("arguments called on a non-function call expression")
export arguments

"""
  unsorted_arguments(x::T)

If x is a expression satisfying `iscall(x)` and your expression type `T` provides
and optimized implementation for storing the arguments, this function can 
be used to retrieve the arguments when the order of arguments does not matter 
but the speed of the operation does.
"""
unsorted_arguments(x) = arguments(x)
export unsorted_arguments


"""
  arity(x)

When `x` satisfies `iscall`, returns the number of arguments of `x`.
Implicitly defined if `arguments(x)` is defined.
"""
arity(x) = length(arguments(x))
export arity


"""
  metadata(x)

Returns the metadata attached to `x`.
"""
metadata(x) = nothing
export metadata


"""
  metadata(expr, md)

Returns a `expr` with metadata `md` attached to it.
"""
function metadata(x, data)
  error("Setting metadata on $x is not implemented")
end

"""
    similarterm(x, op, args, symtype=nothing; metadata=nothing)

"""
function similarterm(x, op, args, symtype = nothing; metadata = nothing)
    Base.depwarn("""`similarterm` is deprecated, use `maketerm` instead.
                    See https://github.com/JuliaSymbolics/TermInterface.jl for details.
                    The present call can be replaced by
                    `maketerm(typeof(x), $(callhead(x)), [op, args...], symtype, metadata)`""")

    maketerm(typeof(x), callhead(x), [op, args...], symtype, metadata)
end

# Old fallback
function similarterm(T::Type, op, args, symtype = nothing; metadata = nothing)
    Base.depwarn("`similarterm` is deprecated, use `maketerm` instead." *
                 "See https://github.com/JuliaSymbolics/TermInterface.jl for details.")
    op(args...)
end

export similarterm


"""
    callhead(x)
Used in this deprecation cycle of `similarterm` to find the `head` argument to
`makterm`. Do not implement this, or use `similarterm` if you're using this package.
"""
callhead(x) = typeof(x)
callhead(x::Expr) = Expr

"""
    maketerm(T, head, children, type, metadata)

Constructs an expression. `T` is a constructor type, `head` and `children` are
the head and tail of the S-expression, `type` is the `type` of the S-expression.
`metadata` is any metadata attached to this expression.

Note that `maketerm` may not necessarily return an object of type `T`. For example,
it may return a representation which is more efficient.

This function is used by term-manipulation routines to construct terms generically.
In these routines, `T` is usually the type of the input expression which is being manipulated.
For example, when a subexpression is substituted, the outer expression is re-constructed with
the sub-expression. `T` will be the type of the outer expression.

Packages providing expression types _must_ implement this method for each expression type.

If your types do not support type information or metadata, you still need to accept
these arguments and may choose to not use them.
"""

function maketerm(T::Type, head, children, type, metadata)
    error("maketerm for $T is not impmlemented")
end

include("utils.jl")

include("expr.jl")

end # module

