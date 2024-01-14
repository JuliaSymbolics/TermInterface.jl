
# This file contains default definitions for TermInterface methods on Julia
# Builtin Expr type.

is_function_call(e::Expr) = _is_function_call_expr_head(e.head)
_is_function_call_expr_head(x::Symbol) = x in (:call, :macrocall)

istree(x::Expr) = true

# See https://docs.julialang.org/en/v1/devdocs/ast/
head(e::Expr) = is_function_call(e) ? e.args[1] : e.head
children(e::Expr) = is_function_call(e) ? e.args[2:end] : e.args

function arity(e::Expr)::Int
  l = length(e.args)
  is_function_call(e) ? l - 1 : l
end

function maketerm(T::Type{Expr}, head, children; is_call=true, type=Any, metadata=nothing)
  if is_call
    Expr(:call, head, children...)
  else
    Expr(head, children...)
  end
end

maketerm(T::Type{Expr}, head::Union{Function,DataType}, children; is_call=true, type=Any, metadata=nothing) =
  maketerm(T, nameof(head), children; is_call, type, metadata)

