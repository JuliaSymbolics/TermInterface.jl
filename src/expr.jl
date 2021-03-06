# This file contains default definitions for TermInterface methods on Julia
# Builtin Expr type.

istree(x::Expr) = true
exprhead(e::Expr) = e.head

operation(e::Expr) = expr_operation(e, Val{exprhead(e)}())
arguments(e::Expr) = expr_arguments(e, Val{exprhead(e)}())

# See https://docs.julialang.org/en/v1/devdocs/ast/
expr_operation(e::Expr, ::Union{Val{:call},Val{:macrocall}}) = e.args[1]
expr_operation(e::Expr, ::Union{Val{:ref}}) = getindex
expr_operation(e::Expr, ::Val{T}) where {T} = T

expr_arguments(e::Expr, ::Union{Val{:call},Val{:macrocall}}) = e.args[2:end]
expr_arguments(e::Expr, _) = e.args


function similarterm(x::Expr, head, args, symtype = nothing; metadata = nothing, exprhead = exprhead(x))
  expr_similarterm(head, args, Val{exprhead}())
end


expr_similarterm(head, args, ::Val{:call}) = Expr(:call, head, args...)
expr_similarterm(head, args, ::Val{:macrocall}) = Expr(:macrocall, head, args...) # discard linenumbernodes?
expr_similarterm(head, args, ::Val{eh}) where {eh} = Expr(eh, args...)
