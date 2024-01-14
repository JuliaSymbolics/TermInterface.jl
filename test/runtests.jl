using TermInterface, Test

@testset "Expr" begin
    ex = :(f(a, b))
    @test head(ex) == ExprHead(:call)
    @test is_function_call(ex) == true
    @test children(ex) == [:f, :a, :b]
    @test operation(ex) == :f
    @test arguments(ex) == [:a, :b]
    @test ex == maketerm(ExprHead(:call), [:f, :a, :b])

    ex = :(arr[i, j])
    @test head(ex) == ExprHead(:ref)
    @test is_function_call(ex) == false
    @test operation(ex) == :ref
    @test arguments(ex) == [:arr, :i, :j]
    @test ex == maketerm(ExprHead(:ref), [:arr, :i, :j])


    ex = :(i, j)
    @test head(ex) == ExprHead(:tuple)
    @test operation(ex) == :tuple
    @test arguments(ex) == [:i, :j]
    @test children(ex) == [:i, :j]
    @test ex == maketerm(ExprHead(:tuple), [:i, :j])

    ex = Expr(:block, :a, :b, :c)
    @test head(ex) == ExprHead(:block)
    @test operation(ex) == :block
    @test children(ex) == arguments(ex) == [:a, :b, :c]
    @test ex == maketerm(ExprHead(:block), [:a, :b, :c])
end

@testset "Custom Struct" begin
    struct Foo
        args
        Foo(args...) = new(args)
    end
    struct FooHead
        head
    end
    TermInterface.head(::Foo) = FooHead(:call)
    TermInterface.head_symbol(q::FooHead) = q.head
    TermInterface.istree(::Foo) = true
    TermInterface.children(x::Foo) = x.args

    t = Foo(1, 2)
    @test head(t) == FooHead(:call)
    @test head_symbol(head(t)) == :call
    @test istree(t) == true
    @test children(t) == [1, 2]
end