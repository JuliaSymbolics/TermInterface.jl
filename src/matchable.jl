""" 
  @matchable struct Foo fields... end [HeadType]

Take a struct definition and automatically define `TermInterface` methods. 
`iscall` of such type will default to `true`.
"""
macro matchable(expr)
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

    quote
        $expr
        TermInterface.isexpr(::$name) = true
        TermInterface.iscall(::$name) = true
        TermInterface.head(::$name) = $name
        TermInterface.operation(::$name) = $name
        TermInterface.children(x::$name) = getfield.((x,), ($(QuoteNode.(fields)...),))
        TermInterface.arguments(x::$name) = TermInterface.children(x)
        TermInterface.arity(x::$name) = $(length(fields))
        Base.length(x::$name) = $(length(fields) + 1)
    end |> esc
end
export @matchable