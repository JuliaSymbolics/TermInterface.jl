"""
  is_head(f)

Returns a single argument anonymous function predicate, that returns `true` if and only if
the argument to the predicate satisfies `istree` and `head(x) == f` 
"""
is_head(f) = @nospecialize(x) -> istree(x) && (head(x) == f)
export is_head


"""
  node_count(t)
Count the nodes in a symbolic expression tree satisfying `istree` and `arguments`.
"""
node_count(t) = istree(t) ? reduce(+, node_count(x) for x in children(t), init = 0) + 1 : 1
export node_count
