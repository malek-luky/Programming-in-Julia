using Test
include("../src/intervals.jl")
include("../src/arithmetic.jl")

#############################################################
# MAIN
#############################################################
x1 = Interval(1,2)
x2 = Interval(2,3)
x3 = Interval(3,6)
x4 = Interval(2.0,4.0)
x5 = Interval(2,4)
x6 = Interval(-2.,2.)
x7 = Interval(-1.,4.)

@testset "IntervalArithmetic" begin
    # STRUCT
    @test string(show(x1)) == "[1, 2]"
    
    # COMPARISON
    @test (x1!=x2) == true
    @test (x1==x1) == true
    @test string(show(-x1)) == "[-2, -1]" #flips a>b must be true
    
    # ADDITION AND SUBSTRACTION
    @test string(show(x1+5)) == "[6, 7]"
    @test (x1+5) == (5+x1)
    @test string(show(x2-1)) == "[1, 2]"
    @test string(show(x1-3)) == "[-2, -1]"
    @test string(show(3-x2)) == "[0, 1]" #flips
    @test string(show(-1-x1)) == "[-3, -2]"
    @test string(show(x1+x2)) == "[3, 5]"
    @test string(show(x1-x2)) == "[-2, 0]"
    
    # MULTIPLICATION AND DIVISION
    @test string(show(3*x1)) == "[3, 6]"
    @test (3*x1) == (x1*3)
    @test string(show(x1*x2)) == "[2, 6]"
    @test string(show(x3/3)) == "[1.0, 2.0]"
    @test string(show(x3/-3)) == "[-2.0, -1.0]"
    @test string(show(inv(x1))) == "[0.5, 1.0]"
    @test string(show(inv(-x1))) == "[-1.0, -0.5]"
    @test (x5/x1) == (x4*inv(x1))
    @test string(show((x5/x1))) == "[1.0, 4.0]"
    @test (-x5/x1) == (-x4*inv(x1))
    @test string(show((-x5/x1))) == "[-4.0, -1.0]"
    @test string(show(inv(x7))) ==  "[-1.0, 0.25]"
    @test (-x5/-x1) == (-x4*inv(-x1))
    @test (x7/x6) == (x7*inv(x6))
    @test string(show((x6/x7))) == "[-2.0, 2.0]"
end