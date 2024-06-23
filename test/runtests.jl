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
    @test ex == maketerm(Expr, :call, [:f, :a, :b], nothing)


    ex = :(arr[i, j])
    @test head(ex) == :ref
    @test_throws ErrorException operation(ex)
    @test_throws ErrorException arguments(ex)
    @test isexpr(ex)
    @test !iscall(ex)
    @test ex == maketerm(Expr, :ref, [:arr, :i, :j], nothing)
end

@testset "Unsorted arguments" begin
    struct Sum
        d::Dict{Int,Any}
        Sum(xs...) = new(Dict{Int,Any}(xs...))
    end

    TermInterface.isexpr(s::Sum) = true
    TermInterface.head(::Sum) = (+)
    TermInterface.operation(s::Sum) = head(s)
    TermInterface.children(s::Sum) = [:($coeff * $val) for (coeff, val) in s.d]
    TermInterface.sorted_children(s::Sum) = [:($coeff * $val) for (coeff, val) in sort!(collect(pairs(s.d)))]
    TermInterface.arguments(s::Sum) = children(s)
    TermInterface.sorted_arguments(s::Sum) = sorted_children(s)

    s = Sum(1 => :A, 2 => :B, 3 => :C)
    @test operation(s) == head(s) == (+)
    args = arguments(s)
    @test :(1A) in args
    @test :(2B) in args
    @test :(3C) in args

    @test sorted_arguments(s) == [:(1A), :(2B), :(3C)]
    @test sorted_children(s) == sorted_arguments(s)
end