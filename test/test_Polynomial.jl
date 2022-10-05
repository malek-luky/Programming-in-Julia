###
#
# Testy související s `Polynomial`.
#

@testset "$(rpad("Polynomial: constructor", TITLE_WIDTH))" begin
  @test typeof(Polynomial([1, 2])) == Polynomial{Int64}
  @test_throws ArgumentError Polynomial(Int64[])
end

@testset "$(rpad("Polynomial: degree", TITLE_WIDTH))" begin
  @test Polynomial([1, 2, 3, 0, 0]).degree == 2
  @test Polynomial([1, 2, 3]).degree == 2
  @test Polynomial([1, 2]).degree == 1
  @test Polynomial([1]).degree == 0
  @test Polynomial([0]).degree == -1
end

@testset "$(rpad("Polynomial: takes care of zero leading coefficient", TITLE_WIDTH))" begin
  p = Polynomial([1, 0, 1, 0, 0])

  @test p.degree == 2
  @test p.coefficients == [1, 0, 1]

  # works even for zero polynomial
  @test Polynomial([0, 0]).coefficients == [0]
end
