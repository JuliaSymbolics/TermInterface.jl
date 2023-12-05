# This file contains default definitions for TermInterface methods on Julia
# Builtin Expr type.

struct ExprHead
  head
end
export ExprHead

head_symbol(eh::ExprHead) = eh.head

istree(x::Expr) = true
head(e::Expr) = ExprHead(e.head)
children(e::Expr) = e.args

# See https://docs.julialang.org/en/v1/devdocs/ast/
function operation(e::Expr)
  h = head(e)
  hh = h.head
  if hh in (:call, :macrocall)
    e.args[1]
  else
    hh
  end
end

function arguments(e::Expr)
  h = head(e)
  hh = h.head
  if hh in (:call, :macrocall)
    e.args[2:end]
  else
    e.args
  end
end

function maketerm(head::ExprHead, children; type=Any, metadata=nothing)
  if !isempty(children) && first(children) isa Union{Function,DataType}
    Expr(head.head, nameof(first(children)), @view(children[2:end])...)
  else
    Expr(head.head, children...)
  end
end
