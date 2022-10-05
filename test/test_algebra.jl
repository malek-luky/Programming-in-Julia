###
#
# Testy související se sčítáním a odčítáním.
#

@testset "$(rpad("Multiplication: simple examples", TITLE_WIDTH))" begin
  # 1 * (1 + 2x + 3x^2) = 1 + 2x + 3x^2
  @test Polynomial([1]) * Polynomial([1, 2, 3]) == Polynomial([1, 2, 3])

  # 2 * (1 + 2x + 3x^2) = 2 + 4x + 6x^2
  @test Polynomial([2]) * Polynomial([1, 2, 3]) == Polynomial([2, 4, 6])

  # x * (1 + 2x + 3x^2) = x + 2x^2 + 3x^3
  @test Polynomial([0, 1]) * Polynomial([1, 2, 3]) == Polynomial([0, 1, 2, 3])

  # x^2 * (1 + 2x + 3x^2) = x^2 + 2x^3 + 3x^4
  @test Polynomial([0, 0, 2]) * Polynomial([1, 2, 3]) == Polynomial([0, 0, 2, 4, 6])

  # (1 + x) * (1 + x) = 1 + 2x + x^2
  @test Polynomial([1, 1]) * Polynomial([1, 1]) == Polynomial([1, 2, 1])

  # (1 + 2x + 3x^2) * (2 + 3x^2)
  @test Polynomial([1, 2, 3]) * Polynomial([2, 0, 3]) == Polynomial([2, 4, 9, 6, 9])
end

@testset "$(rpad("Addition: simple examples", TITLE_WIDTH))" begin
  @test Polynomial([1, 2, 3, 4]) + Polynomial([1, -3]) == Polynomial([2, -1, 3, 4])

  @test Polynomial([1, -1]) + Polynomial([0, 0]) == Polynomial([1, -1])

  @test Polynomial([1, -1]) + Polynomial([-1, 1]) == Polynomial([0])

  @test Polynomial([0, 0, 2, 3]) + Polynomial([0, 1, -2, -3]) == Polynomial([0, 1])
end
