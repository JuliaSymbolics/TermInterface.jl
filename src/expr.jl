# This file contains default definitions for TermInterface methods on Julia
# Builtin Expr type.

istree(x::Type{Expr}) = true
exprhead(e::Expr) = e.head

operation(e::Expr) = expr_operation(e, Val{exprhead(e)}())
arguments(e::Expr) =  expr_arguments(e, Val{exprhead(e)}())

# See https://docs.julialang.org/en/v1/devdocs/ast/
expr_operation(e::Expr, ::Union{Val{:call}, Val{:macrocall}}) = e.args[1]
expr_operation(e::Expr, ::Val{T}) where {T} = T

expr_arguments(e::Expr, ::Union{Val{:call}, Val{:macrocall}}) = e.args[2:end]
expr_arguments(e::Expr, _) = e.args


function similarterm(x::Type{Expr}, head, args, symtype=nothing; metadata=nothing, exprhead=:call)
    expr_similarterm(head, args, Val{exprhead}())
end

expr_similarterm(head, args, ::Val{:call}) = Expr(:call, head, args...)
expr_similarterm(head, args, ::Val{:macrocall}) = Expr(:call, head, args...) # discard linenumbernodes?
expr_similarterm(head, args, ::Val{eh}) where {eh} = Expr(eh, args...)
