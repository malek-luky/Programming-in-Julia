##
#
# Testy související s `IsingPeriodic` a `IsingFixed`
#

@testset "$(rpad("IsingPerodic: constructor", TITLE_WIDTH))" begin
  @test isa(IsingPeriodic(10, 10), IsingPeriodic)
  @test_throws ArgumentError IsingPeriodic(10, 10, β=-10.)
end

@testset "$(rpad("IsingFixed: constructor", TITLE_WIDTH))" begin
  @test isa(IsingFixed(ones(10, 10)), IsingFixed)
  @test_throws ArgumentError IsingFixed(ones(10, 10), β=-10.)
end
