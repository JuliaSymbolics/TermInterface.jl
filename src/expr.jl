# This file contains default definitions for TermInterface methods on Julia
# Builtin Expr type.

istree(x::Expr) = true

operation(e::Expr) = e.head
arguments(e::Expr) = e.args

function similarterm(x::Expr, head, args, symtype = nothing; metadata = nothing)
  Expr(head, args...)
end