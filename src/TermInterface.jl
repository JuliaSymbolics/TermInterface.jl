module TermInterface

"""
  istree(x)

Returns `true` if `x` is a term. If true, `operation`, `arguments`
must also be defined for `x` appropriately.
"""
istree(x) = false
export istree

"""
  symtype(x)

Returns the symbolic type of `x`. By default this is just `typeof(x)`.
Define this for your symbolic types if you want `SymbolicUtils.simplify` to apply rules
specific to numbers (such as commutativity of multiplication). Or such
rules that may be implemented in the future.
"""
function symtype(x)
  typeof(x)
end
export symtype

"""
  issym(x)

Returns `true` if `x` is a symbol. If true, `nameof` must be defined
on `x` and must return a Symbol.
"""
issym(x) = false
export issym

"""
  exprhead(x)

If `x` is a term as defined by `istree(x)`, `exprhead(x)` must return a symbol,
corresponding to the head of the `Expr` most similar to the term `x`.
If `x` represents a function call, for example, the `exprhead` is `:call`.
If `x` represents an indexing operation, such as `arr[i]`, then `exprhead` is `:ref`.
Note that `exprhead` is different from `operation` and both functions should 
be defined correctly in order to let other packages provide code generation 
and pattern matching features. 
"""
function exprhead end
export exprhead

"""
  head(x)

If `x` is a term as defined by `istree(x)`, `head(x)` returns the head of the
term if `x`. The `head` type has to be provided by the package.
"""
function head end
export head

"""
  head_symbol(x::HeadType)

If `x` is a head object, `head_symbol(T, x)` returns a `Symbol` object that
corresponds to `y.head` if `y` was the representation of the corresponding term
as a Julia Expression. This is useful to define interoperability between
symbolic term types defined in different packages and should be used when
calling `maketerm`.
"""
function head_symbol end
export head_symbol

"""
  tail(x)

Get the arguments of `x`, must be defined if `istree(x)` is `true`.
"""
function tail end
export tail


"""
  operation(x)

If `x` is a term as defined by `istree(x)`, `operation(x)` returns the
operation of the term if `x` represents a function call, for example, the head
is the function being called.
"""
function operation end
export operation

"""
  arguments(x)

Get the arguments of `x`, must be defined if `istree(x)` is `true`.
"""
function arguments end
export arguments


"""
  unsorted_arguments(x::T)

If x is a term satisfying `istree(x)` and your term type `T` orovides
and optimized implementation for storing the arguments, this function can 
be used to retrieve the arguments when the order of arguments does not matter 
but the speed of the operation does.
"""
unsorted_arguments(x) = arguments(x)
export unsorted_arguments


"""
  arity(x)

Returns the number of arguments of `x`. Implicitly defined 
if `arguments(x)` is defined.
"""
arity(x) = length(arguments(x))
export arity


"""
  metadata(x)

Return the metadata attached to `x`.
"""
metadata(x) = nothing
export metadata


"""
  metadata(x, md)

Returns a new term which has the structure of `x` but also has
the metadata `md` attached to it.
"""
function metadata(x, data)
  error("Setting metadata on $x is not possible")
end


"""
  maketerm(head::H, tail; type=Any, metadata=nothing)

Has to be implemented by the provider of H.
Returns a term that is in the same closure of types as `typeof(x)`,
with `head` as the head and `tail` as the arguments, `type` as the symtype
and `metadata` as the metadata. 
"""
function maketerm(head, tail; type=Any, metadata=nothing) end
export maketerm

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

include("expr.jl")

""" 
  @matchable struct Foo fields... end [HeadType]

Take a struct definition and automatically define `TermInterface` methods. This
will automatically define a head type. If `HeadType` is given then it will be
used as `head(::Foo)`. If it is omitted, and the struct is called `Foo`, then
the head type will be called `FooHead`. The `head_symbol` of such head types
will default to `:call`.
"""
macro matchable(expr, head_name=nothing)
  @assert expr.head == :struct
  name = expr.args[2]
  if name isa Expr
    name.head === :(<:) && (name = name.args[1])
    name isa Expr && name.head === :curly && (name = name.args[1])
  end
  fields = filter(x -> x isa Symbol || (x isa Expr && x.head == :(::)), expr.args[3].args)
  get_name(s::Symbol) = s
  get_name(e::Expr) = (@assert(e.head == :(::)); e.args[1])
  fields = map(get_name, fields)
  head_name = isnothing(head_name) ? Symbol(name, :Head) : head_name

  quote
    $expr
    struct $head_name
      head
    end
    TermInterface.head_symbol(x::$head_name) = x.head
    # TODO default to call?
    TermInterface.head(::$name) = $head_name(:call)
    TermInterface.istree(::$name) = true
    TermInterface.operation(::$name) = $name
    TermInterface.arguments(x::$name) = getfield.((x,), ($(QuoteNode.(fields)...),))
    TermInterface.tail(x::$name) = [operation(x); arguments(x)...]
    TermInterface.arity(x::$name) = $(length(fields))
    Base.length(x::$name) = $(length(fields) + 1)
  end |> esc
end
export @matchable

end # module

