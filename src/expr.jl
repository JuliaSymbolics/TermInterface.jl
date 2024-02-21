# This file contains default definitions for TermInterface methods on Julia
# Builtin Expr type.

iscall(x::Expr) = x.head == :call

head(e::Expr) = e.head
children(e::Expr) = e.args

operation(e::Expr) = e.args[1]
arguments(e::Expr) = e.args[2:end]

function maketerm(::Type{Expr}, head, args, symtype, metadata)
    Expr(head, args...)
end
