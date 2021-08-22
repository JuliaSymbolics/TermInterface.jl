# TermInterface.jl

This package contains definitions for common functions that are useful for symbolic expression manipulation.
Its purpose is to provide a shared interface between various symbolic programming Julia packages, for example 
[SymbolicUtils.jl](https://github.com/JuliaSymbolics/SymbolicUtils.jl), [Symbolics.jl](https://github.com/JuliaSymbolics/Symbolics.jl) and [Metatheory.jl](https://github.com/0x0f0f0f/Metatheory.jl).

## Docs
You should define the following methods for an expression tree type `T` with symbol types `S` to  work
with TermInterface.jl, and therefore with [SymbolicUtils.jl](https://github.com/JuliaSymbolics/SymbolicUtils.jl) 
and [Metatheory.jl](https://github.com/0x0f0f0f/Metatheory.jl).

#### `isterm(x::T)` or `isterm(x::Type{T})`

Check if `x` represents an expression tree. If returns true,
it will be assumed that `gethead(::T)` and `getargs(::T)`
methods are defined. Definining these three should allow use
of `SymbolicUtils.simplify` on custom types. Optionally `symtype(x)` can be
defined to return the expected type of the symbolic expression.

#### `gethead(x::T)`

Returns the head (a function object) performed by an expression
tree. Called only if `isterm(::T)` is true. Part of the API required
for `simplify` to work. Other required methods are `getargs` and `isterm`

#### `getargs(x::T)`

Returns the arguments (a `Vector`) for an expression tree.
Called only if `isterm(x)` is `true`. Part of the API required
for `simplify` to work. Other required methods are `gethead` and `isterm`

In addition, the methods for `Base.hash` and `Base.isequal` should also be implemented by the types for the purposes of substitution and equality matching respectively.

#### `similarterm(t::MyType, f, args; type=T, metadata=nothing)`

Or `similarterm(t::Type{MyType}, f, args; type=T, metadata=nothing)`.

Construct a new term with the operation `f` and arguments `args`, the term should be similar to `t` in type. if `t` is a `SymbolicUtils.Term` object a new Term is created with the same symtype as `t`. If not, the result is computed as `f(args...)`. Defining this method for your term type will reduce any performance loss in performing `f(args...)` (esp. the splatting, and redundant type computation). T is the symtype of the output term. You can use `SymbolicUtils.promote_symtype` to infer this type.

### Optional

#### `symtype(x)`

The supposed type of values in the domain of x. Tracing tools can use this type to
pick the right method to run or analyse code.

This defaults to `typeof(x)` if `x` is numeric, or `Any` otherwise.
For the types defined in this SymbolicUtils.jl, namely `T<:Symbolic{S}` it is `S`.

Define this for your symbolic types if you want `SymbolicUtils.simplify` to apply rules
specific to numbers (such as commutativity of multiplication). Or such
rules that may be implemented in the future.

## Example

Suppose you were feeling the temptations of type piracy and wanted to make a quick and dirty
symbolic library built on top of Julia's `Expr` type, e.g.

```julia
for f ∈ [:+, :-, :*, :/, :^] #Note, this is type piracy!
    @eval begin
        Base.$f(x::Union{Expr, Symbol}, y::Number) = Expr(:call, $f, x, y)
        Base.$f(x::Number, y::Union{Expr, Symbol}) = Expr(:call, $f, x, y)
        Base.$f(x::Union{Expr, Symbol}, y::Union{Expr, Symbol}) = (Expr(:call, $f, x, y))
    end
end

Base.zero(t::Expr) = 0

ex = 1 + (:x - 2)
```


How can we use SymbolicUtils.jl to convert `ex` to `(-)(:x, 1)`? We simply implement `isterm`,
`head`, `arguments` and we'll be able to do rule-based rewriting on `Expr`s:
```julia
using TermInterface
using SymbolicUtils


TermInterface.isterm(ex::Expr) = ex.head == :call
TermInterface.gethead(ex::Expr) = ex.args[1]
TermInterface.getargs(ex::Expr) = ex.args[2:end]
TermInterface.similarterm(x::Type{Expr}, head, args; type=nothing, metadata=nothing) = Expr(:call, head, args...)

@rule(~x => ~x - 1)(ex)
```

However, this is not enough to get SymbolicUtils to use its own algebraic simplification system on `Expr`s:
```julia
simplify(ex)
```

The reason that the expression was not simplified is that the expression tree is untyped, so SymbolicUtils 
doesn't know what rules to apply to the expression. To mimic the behaviour of most computer algebra 
systems, the simplest thing to do would be to assume that all `Expr`s are of type `Number`:

```julia
TermInterface.symtype(s::Expr) = Real
TermInterface.symtype(s::Sym) = Real

simplify(ex)
```

Now SymbolicUtils is able to apply the `Number` simplification rule to `Expr`.
