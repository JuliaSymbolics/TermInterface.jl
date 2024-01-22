# This file contains default definitions for TermInterface methods on Julia
# Builtin Expr type.

struct ExprHead
  head
end
export ExprHead

istree(x::Expr) = true
head(e::Expr) = ExprHead(e.head)
children(e::Expr) = e.args

function maketerm(head::ExprHead, children; type=Any, metadata=nothing)
  if !isempty(children) && first(children) isa Union{Function,DataType}
    Expr(head.head, nameof(first(children)), @view(children[2:end])...)
  else
    Expr(head.head, children...)
  end
end
