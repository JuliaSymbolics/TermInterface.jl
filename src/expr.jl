# This file contains default definitions for TermInterface methods on Julia
# Builtin Expr type.

struct ExprHead
  head
end
export ExprHead

istree(x::Expr) = true
head(e::Expr) = ExprHead(head)
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
  expr_arguments(e, Val{exprhead(e)}())
end

function similarterm(x::Expr, head, args, symtype=nothing; metadata=nothing, exprhead=exprhead(x))
  expr_similarterm(head, args, Val{exprhead}())
end

maketerm(head::ExprHead, tail; type=Any, metadata=nothing) = Expr(head.head, tail...)