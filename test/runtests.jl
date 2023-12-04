using TermInterface
using Test

@testset "Expr" begin
    ex = :(f(a, b))
    @test head(ex) == ExprHead(:call)
    @test tail(ex) == [:f, :a, :b]
    @test operation(ex) == :f
    @test arguments(ex) == [:a, :b]
    @test ex == maketerm(ExprHead(:call), [:f, :a, :b])

    ex = :(arr[i, j])
    @test head(ex) == ExprHead(:ref)
    @test operation(ex) == getindex
    @test arguments(ex) == [:arr, :i, :j]
    @test ex == maketerm(ExprHead(:ref), [:arr, :i, :j])

    ex = Expr(:block, :a, :b, :c)
    @test head(ex) == ExprHead(:block)
    @test operation(ex) == :block
    @test tail(ex) == arguments(ex) == [:a, :b, :c]
    @test ex == maketerm(ExprHead(:block), [:a, :b, :c])
end
