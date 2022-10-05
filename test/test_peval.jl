###
#
# Testy související s vyhodnocováním funkční hodnoty.
#

@testset "$(rpad("Evaluation: simple examples", TITLE_WIDTH))" begin
  @test Polynomial([1])(2) == 1

  @test Polynomial([1])(1) == 1

  @test Polynomial([0, 1])(1) == 1

  @test Polynomial([0, 1])(2) == 2

  @test Polynomial([1, 2, 1])(-1) == 0

  @test Polynomial([1, 2, 1])(2) == 9

  @test Polynomial([1//2, 3//2])(6) == 19//2
end
