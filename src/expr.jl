# This file contains default definitions for TermInterface methods on Julia
# Builtin Expr type.

iscall(x::Expr) = x.head == :call

head(e::Expr) = e.head
children(e::Expr) = e.args

# ^ this will implicitly define operation and arguments

function maketerm(::Type{Expr}, head, args, symtype, metadata)
    Expr(head, args...)
end
