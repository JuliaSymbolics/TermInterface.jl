# TermInterface.jl

This package contains definitions for common functions that are useful for symbolic expression manipulation.
Its purpose is to provide a shared interface between various symbolic programming Julia packages, for example 
[SymbolicUtils.jl](https://github.com/JuliaSymbolics/SymbolicUtils.jl), [Symbolics.jl](https://github.com/JuliaSymbolics/Symbolics.jl) and [Metatheory.jl](https://github.com/0x0f0f0f/Metatheory.jl).

## Docs
You should define the following methods for an expression tree type `T` with symbol types `S` to  work
with TermInterface.jl, and therefore with [SymbolicUtils.jl](https://github.com/JuliaSymbolics/SymbolicUtils.jl) 
and [Metatheory.jl](https://github.com/0x0f0f0f/Metatheory.jl).

#### `isexpr(x::T)` 

Returns `true` if `x` is an expression tree (an S-expression). If true, `head`
and `children` methods must be defined for `x`.

#### `head(x)`

Returns the head of the S-expression.

#### `children(x)`

Returns the children (aka tail) of the S-expression.

#### `maketerm(T, head, children, type=nothing, metadata=nothing)`

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

#### `iscall(x::T)`

Returns `true` if `x` is a function call expression. If true, `operation`, `arguments` must also be defined for `x::T`.

#### `operation(x)`

Returns the function a function call expression is calling. `iscall(x)` must be
true as a precondition.

#### `arguments(x)`

Returns the arguments to the function call in a function call expression.
`iscall(x)` must be true as a precondition.

### Optional

#### `arity(x)`

When `x` satisfies `iscall`, returns the number of arguments of `x`.
Implicitly defined if `arguments(x)` is defined.


#### `metadata(x)`

Returns the metadata attached to `x`.

#### `symtype(expr)`

Returns the symbolic type of `expr`. By default this is just `typeof(expr)`.
Define this for your symbolic types if you want `SymbolicUtils.simplify` to apply rules
specific to numbers (such as commutativity of multiplication). Or such
rules that may be implemented in the future.

<!-- TODO update examples -->
