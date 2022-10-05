###
#
# Testy související s `pdiv`.
#

@testset "$(rpad("pdiv: simple examples", TITLE_WIDTH))" begin
  # (1 + x) / (1 + 2x + 3x^2)
  @test_throws ArgumentError pdiv(Polynomial([1, 2]), Polynomial([0]))

  @test pdiv(Polynomial([1, 2]), Polynomial([1, 2, 3])) == (Polynomial([1, 2]), Polynomial([1, 2, 3]))

  # x / x = 1 + 0 / x
  @test pdiv(Polynomial([0, 1]), Polynomial([0, 1])) == (Polynomial([1]), Polynomial([0]))

  # x / (1 + x) = 1 + (-1) / (1 + x)
  @test pdiv(Polynomial([0, 1]), Polynomial([1, 1])) == (Polynomial([1]), Polynomial([-1]))

  # x^2 / (1 + x) = (x - 1) + 1 / (1 + x)
  @test pdiv(Polynomial([0, 0, 1]), Polynomial([1, 1])) == (Polynomial([-1, 1]), Polynomial([1]))
end

@testset "$(rpad("pdiv: more involved examples", TITLE_WIDTH))" begin
  # Floats
  p = Polynomial([4., -2., 3., 0., 2., 5.])
  q = Polynomial([-3., -2., 1., 3.])
  quotient, remainder = pdiv(p, q)

  @test p == quotient * q + remainder

  # Rational
  p = Polynomial([4 // 3, -2, 3 // 2, 0, - 7 // 9, 5 // 11])
  q = Polynomial([-3, -2, 1 // 8, 3 // 5])
  quotient, remainder = pdiv(p, q)

  @test p == quotient * q + remainder
end
