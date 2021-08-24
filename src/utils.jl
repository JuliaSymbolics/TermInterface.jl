"""
    is_operation(f)

Returns a single argument anonymous function predicate, that returns `true` if and only if
the argument to the predicate satisfies `isterm` and `gethead(x) == f` 
"""
is_operation(f) = @nospecialize(x) -> isterm(x) && (gethead(x) == f)
export is_operation