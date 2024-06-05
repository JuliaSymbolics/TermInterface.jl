# TermInterface.jl Documentation

This package contains definitions for common functions that are useful for symbolic expression manipulation.
Its purpose is to provide a shared interface between various symbolic programming Julia packages, for example 
[SymbolicUtils.jl](https://github.com/JuliaSymbolics/SymbolicUtils.jl), [Symbolics.jl](https://github.com/JuliaSymbolics/Symbolics.jl) and [Metatheory.jl](https://github.com/0x0f0f0f/Metatheory.jl).

You should define the following methods for your expression tree type to work
with TermInterface.jl, and therefore with [SymbolicUtils.jl](https://github.com/JuliaSymbolics/SymbolicUtils.jl) 
and [Metatheory.jl](https://github.com/0x0f0f0f/Metatheory.jl).

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

## API Docs

```@autodocs
Modules = [TermInterface]
```

