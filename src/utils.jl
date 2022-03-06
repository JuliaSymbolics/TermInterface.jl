"""
  is_operation(f)

Returns a single argument anonymous function predicate, that returns `true` if and only if
the argument to the predicate satisfies `istree` and `operation(x) == f` 
"""
is_operation(f) = @nospecialize(x) -> istree(x) && (operation(x) == f)
export is_operation


"""
  node_count(t)
Count the nodes in a symbolic expression tree satisfying `istree` and `arguments`.
"""
node_count(t) = istree(t) ? reduce(+, node_count(x) for x in arguments(t), init = 0) + 1 : 1
export node_count