# TermInterface.jl

This package contains definitions for common functions that are useful for symbolic expression manipulation.
Its purpose is to provide a shared interface between various symbolic programming Julia packages, for example 
[SymbolicUtils.jl](https://github.com/JuliaSymbolics/SymbolicUtils.jl), [Symbolics.jl](https://github.com/JuliaSymbolics/Symbolics.jl) and [Metatheory.jl](https://github.com/0x0f0f0f/Metatheory.jl).

## Docs
You should define the following methods for an expression tree type `T` with symbol types `S` to  work
with TermInterface.jl, and therefore with [SymbolicUtils.jl](https://github.com/JuliaSymbolics/SymbolicUtils.jl) 
and [Metatheory.jl](https://github.com/0x0f0f0f/Metatheory.jl).

#### `isexpr(x::T)` 

Returns `true` if `x` is an expression tree. If true, `head(x)` and `children(x)` methods must be defined for `x`.
Optionally, if `x` represents a function call, `iscall(x)` should be true, and `operation(x)` and `arguments(x)` should also be defined. 

#### `iscall(x::T)`

Returns `true` if `x` is a function call expression. If true, `operation(x)`, `arguments(x)`
must also be defined for `x`.

If `iscall(x)` is true, then also `isexpr(x)` *must* be true. The other way around is not true.
(A function call is always an expression node, but not every expression tree represents a function call).

This means that, `head(x)` and `children(x)` must be defined. Together
with `operation(x)` and `arguments(x)`. 

**Examples:** 

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

#### `head(x)`

Returns the head of the S-expression.

#### `children(x)`

Returns the children (aka tail) of the S-expression.

#### `operation(x)`

Returns the function a function call expression is calling. `iscall(x)` must be
true as a precondition.

#### `arguments(x)`

Returns the arguments to the function call in a function call expression.
`iscall(x)` must be true as a precondition.

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


### Optional

#### `arity(x)`

When `x` satisfies `iscall`, returns the number of arguments of `x`.
Implicitly defined if `arguments(x)` is defined.


#### `metadata(x)`

Returns the metadata attached to `x`.

####  `metadata(expr, md)`

Returns `expr` with metadata `md` attached to it.

## Examples

### Function call Julia Expressions

```julia 
ex = :(f(a, b))
@test head(ex) == :call
@test children(ex) == [:f, :a, :b]
@test operation(ex) == :f
@test arguments(ex) == [:a, :b]
@test isexpr(ex)
@test iscall(ex)
@test ex == maketerm(Expr, :call, [:f, :a, :b], nothing)
```


### Non-function call Julia Expressions

```julia 
ex = :(arr[i, j])
@test head(ex) == :ref
@test_throws ErrorException operation(ex)
@test_throws ErrorException arguments(ex)
@test isexpr(ex)
@test !iscall(ex)
@test ex == maketerm(Expr, :ref, [:arr, :i, :j], nothing)
```