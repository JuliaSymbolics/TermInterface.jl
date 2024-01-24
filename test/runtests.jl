using TermInterface
using Test

@testset "Expr" begin
    ex = :(f(a, b))
    @test operation(ex) == :call
    @test arguments(ex) == [:f, :a, :b]
    @test ex == similarterm(ex, :call, [:f, :a, :b])

    ex = :(arr[i, j])
    @test operation(ex) == :ref
    @test arguments(ex) == [:arr, :i, :j]
    @test ex == similarterm(ex, :ref, [:arr, :i, :j])
end
