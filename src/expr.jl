# This file contains default definitions for TermInterface methods on Julia
# Builtin Expr type.

struct ExprHead
  head
end
export ExprHead

istree(x::Expr) = true
head(e::Expr) = ExprHead(e.head)
children(e::Expr) = e.args

is_function_call(e::Expr) = head(e).head in (:call, :macrocall)

# See https://docs.julialang.org/en/v1/devdocs/ast/
function operation(e::Expr)
  h = head(e)
  hh = h.head
  if hh in (:call, :macrocall)
    e.args[1]
  else
    throw(ArgumentError("Not a function call"))
  end
end

function arguments(e::Expr)
  h = head(e)
  hh = h.head
  if hh in (:call, :macrocall)
    e.args[2:end]
  else
    throw(ArgumentError("Not a function call"))
  end
end

function maketerm(head::ExprHead, children; type=Any, metadata=nothing)
  if !isempty(children) && first(children) isa Union{Function,DataType}
    Expr(head.head, nameof(first(children)), @view(children[2:end])...)
  else
    Expr(head.head, children...)
  end
end
