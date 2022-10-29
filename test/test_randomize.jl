##
#
# Testy související s `randomize!`
#

@testset "$(rpad("randomize!: IsingPeriodic", TITLE_WIDTH))" begin
  model = IsingPeriodic(1_000, 1_000)
  fill!(model.sites, 1)
  randomize!(model)

  # It is highly probable there will be at least one change
  @test abs((sum(model.sites - ones(1_000, 1_000)))) > 0
end

@testset "$(rpad("randomize!: IsingFixed", TITLE_WIDTH))" begin
  model = IsingFixed(ones(1_000, 1_000))
  randomize!(model)

  # It is highly probable there will be at least one change
  @test abs((sum(model.sites - ones(1_000, 1_000)))) > 0

  # and it does not change the boundary!
  @test model.sites[1,       1:1_000] ≈ ones(1_000)
  @test model.sites[1_000,   1:1_000] ≈ ones(1_000)
  @test model.sites[1:1_000, 1]       ≈ ones(1_000)
  @test model.sites[1:1_000, 1_000]   ≈ ones(1_000)
end

