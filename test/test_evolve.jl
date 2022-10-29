##
#
# Testy související s `evolve!`
#

@testset "$(rpad("evolve!: simple test", TITLE_WIDTH))" begin
  model = IsingPeriodic(10, 10)

  # evolve! flips exactly one spin site in one time step.
  randomize!(model)
  initial_configuration = copy(model.sites)
  evolve!(model, 1, 1_000_000)
  @test abs(sum(model.sites - initial_configuration)) ≈ 2.0
end
