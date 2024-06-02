module TermInterface

"""
    isexpr(x)
Returns `true` if `x` is an expression tree. If true, `head(x)` and `children(x)` methods must be defined for `x`.
Optionally, if `x` represents a function call, `iscall(x)` should be true, and `operation(x)` and `arguments(x)` should also be defined. 
"""
isexpr(x) = false
export isexpr

"""
    iscall(x)
Returns `true` if `x` is a function call expression. If true, `operation(x)`, `arguments(x)`
must also be defined for `x`.

If `iscall(x)` is true, then also `isexpr(x)` *must* be true. The other way around is not true.
(A function call is always an expression node, but not every expression tree represents a function call).

This means that, `head(x)` and `children(x)` must be defined. Together
with `operation(x)` and `arguments(x)`. 

## Examples 

In a functional language, all expression trees are function calls (e.g. SymbolicUtils.jl).
Let's say that you have an hybrid array and functional language. `iscall` on the expression `v[i]`
is `false`, and `iscall` on expression `f(x)` is `true`, but both of them are nested
expressions, and `isexpr` is `true` on both.

The same goes for Julia `Expr`. An `Expr(:block, ...)` is *not a function call*
and has no `operation` and `arguments`, but has a `head` and `children`.


The distinction between `head`/`children` and `operation`/`arguments` is needed 
when dealing with languages that are *not representing function call operations as their head*.
The main example is  `Expr(:call, :f, :x)`: it has both a `head` and an `operation`, which are
respectively `:call` and `:f`.

In other symbolic expression languages, such as SymbolicUtils.jl, the `head` of a node 
can correspond to `operation` and `children` can correspond to `arguments`.
"""
iscall(x) = false
export iscall

"""
    head(x)
Returns the head of the S-expression.
"""
function head end
export head

"""
    children(x)
Returns the children (aka tail) of the S-expression.
"""
function children end
export children

"""
  operation(x)

Returns the function a function call expression is calling.
`iscall(x)` must be true as a precondition.
"""
function operation end
export operation

"""
  arguments(x)

Returns the arguments to the function call in a function call expression.
`iscall(x)` must be true as a precondition.
"""
function arguments end
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
function metadata end


"""
    maketerm(T, head, children, metadata)

Constructs an expression. `T` is a constructor type, `head` and `children` are
the head and tail of the S-expression.
`metadata` is any metadata attached to this expression.

Note that `maketerm` may not necessarily return an object of type `T`. For example,
it may return a representation which is more efficient.

This function is used by term-manipulation routines to construct terms generically.
In these routines, `T` is usually the type of the input expression which is being manipulated.
For example, when a subexpression is substituted, the outer expression is re-constructed with
the sub-expression. `T` will be the type of the outer expression.

Packages providing expression types _must_ implement this method for each expression type.

Giving `nothing` for `metadata` should result in a default being selected.
"""

function maketerm end
export maketerm

include("utils.jl")

include("expr.jl")

end # module

