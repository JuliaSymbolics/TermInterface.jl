"""
    is_operation(f)

Returns a single argument anonymous function predicate, that returns `true` if and only if
the argument to the predicate satisfies `isterm` and `gethead(x) == f` 
"""
is_operation(f) = @nospecialize(x) -> isterm(x) && (gethead(x) == f)
export is_operation


"""
    node_count(t)
Count the nodes in a symbolic expression tree satisfying `isterm` and `getargs`.
"""
node_count(t) = isterm(t) ? reduce(+, node_count(x) for x in  getargs(t), init=0) + 1 : 1
export node_count