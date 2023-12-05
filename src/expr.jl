# This file contains default definitions for TermInterface methods on Julia
# Builtin Expr type.

struct ExprHead
  head
end
export ExprHead

head_symbol(eh::ExprHead) = eh.head

istree(x::Expr) = true
head(e::Expr) = ExprHead(e.head)
tail(e::Expr) = e.args

# See https://docs.julialang.org/en/v1/devdocs/ast/
function operation(e::Expr)
  h = head(e)
  hh = h.head
  if hh in (:call, :macrocall)
    e.args[1]
  elseif hh == :ref
    getindex
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

function maketerm(head::ExprHead, tail; type=Any, metadata=nothing)
  if !isempty(tail) && first(tail) isa Union{Function,DataType}
    Expr(head.head, nameof(first(tail)), @view(tail[2:end])...)
  else
    Expr(head.head, tail...)
  end
end
