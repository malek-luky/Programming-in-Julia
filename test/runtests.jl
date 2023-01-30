using Test
include("../src/intervals.jl")
include("../src/arithmetic.jl")

#############################################################
# RUN TESTS
#############################################################
x1 = Interval(1,2)
x2 = Interval(2,3)
x3 = Interval(3,6)
x5 = Interval(2,4)
x6 = Interval(-2.,2.)
x7 = Interval(-1.,4.)

@testset "IntervalArithmetic" begin
    
    # COMPARISON
    @test (x1!=x2) == true
    @test (x1==x1) == true
    @test -x1 == Interval(-2,-1) #flips a>b must be true

    # ADDITION AND SUBSTRACTION
    @test x1+5 == Interval(6, 7)
    @test (x1+5) == (5+x1)
    @test x2-1 == Interval(1, 2)
    @test x1-3 == Interval(-2, -1)
    @test 3-x2 == Interval(0, 1) #flips
    @test -1-x1 == Interval(-3, -2)
    @test x1+x2 == Interval(3, 5)
    @test x1-x2 == Interval(-2, 0)
    
    # MULTIPLICATION AND DIVISION
    @test 3*x1 == Interval(3, 6)
    @test (3*x1) == (x1*3)
    @test x1*x2 == Interval(2, 6)
    @test x3/3 == Interval(1.0, 2.0)
    @test x3/-3 == Interval(-2.0, -1.0)
    @test inv(x1) == Interval(0.5, 1.0)
    @test inv(-x1) == Interval(-1.0, -0.5)
    @test (x5/x1) == (x5*inv(x1))
    @test (x5/x1) == Interval(1.0, 4.0)
    @test (-x5/x1) == (-x5*inv(x1))
    @test (-x5/x1) == Interval(-4.0, -1.0)
    @test (-x5/-x1) == (-x5*inv(-x1))
    
    # ERRORS ON PURPOSE
    @test_throws "a>b" inv(x7) ==  Interval(-1.0, 0.25)
    @test_throws "Division by Interval with zero" (x7/x6) == (x7*inv(x6))
    @test_throws "Division by Interval with zero" (x6/x7) == Interval(-2.0, 2.0)
    @test_throws "Division by zero" (x6/0) == Interval(-2.0, 2.0)
end