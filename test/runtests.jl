using TermInterface
using Test

@testset "Expr" begin
    ex = :(f(a, b))
    @test head(ex) == :call
    @test children(ex) == [:f, :a, :b]
    @test operation(ex) == :f
    @test arguments(ex) == [:a, :b]
    @test isexpr(ex)
    @test iscall(ex)
    @test ex == maketerm(Expr, :call, [:f, :a, :b])


    ex = :(arr[i, j])
    @test head(ex) == :ref
    @test_throws ErrorException operation(ex)
    @test_throws ErrorException arguments(ex)
    @test isexpr(ex)
    @test !iscall(ex)
    @test ex == maketerm(Expr, :ref, [:arr, :i, :j])
end

@testset "Matchable Structs" begin
    @matchable struct Lux
        a
        b
    end

    t = Lux(:a, :b)
    @test isexpr(t)
    @test iscall(t)
    @test head(t) == Lux
    @test operation(t) == Lux
    @test collect(children(t)) == [:a, :b]
    @test collect(arguments(t)) == [:a, :b]
end
