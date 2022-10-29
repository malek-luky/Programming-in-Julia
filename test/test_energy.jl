##
#
# Testy související s výpočtem energie
#

@testset "$(rpad("IsingFixed: energy", TITLE_WIDTH))" begin
  #
  # J = ones(3, 3), h = zeros(3, 3) and configuration
  #
  # 1 1 1
  # 1 1 1
  # 1 1 1
  #
  model = IsingFixed(ones(3, 3), ones(3, 3), h=zeros(3, 3))

  @test energy(model) ≈ -20.

  #
  # J = ones(3, 3), h = ones(3, 3) and configuration
  #
  # 1 1 1
  # 1 1 1
  # 1 1 1
  #
  model = IsingFixed(ones(3, 3), ones(3, 3), h=ones(3, 3))

  @test energy(model) ≈ -29.


  #
  # J = ones(3, 3), h = zeros(3, 3) and configuration
  #
  # -1  1  1
  #  1 -1  1
  #  1  1 -1
  #
  model = IsingFixed([-1. 1. 1.; 1. -1. 1.; 1. 1. -1.], ones(3, 3), h=zeros(3, 3))

  @test energy(model) ≈ 0.

  #
  # J = ones(3, 3), h = ones(3, 3) and configuration
  #
  # -1  1  1
  #  1 -1  1
  #  1  1 -1
  #
  model = IsingFixed([-1. 1. 1.; 1. -1. 1.; 1. 1. -1.], ones(3, 3), h=ones(3, 3))

  @test energy(model) ≈ -3.
end

@testset "$(rpad("IsingPeriodic: energy", TITLE_WIDTH))" begin
  #
  # J = ones(3, 3), h = zeros(3, 3) and configuration
  #
  # 1 1 1
  # 1 1 1
  # 1 1 1
  #
  model = IsingPeriodic(3, 3, ones(3, 3), h=zeros(3, 3))
  fill!(model.sites, 1)

  @test energy(model) ≈ -36.

  #
  # J = ones(3, 3), h = -ones(3, 3) and configuration
  #
  # 1 1 1
  # 1 1 1
  # 1 1 1
  #
  model = IsingPeriodic(3, 3, ones(3, 3), h=-ones(3, 3))

  @test energy(model) ≈ -27.


  #
  # J = ones(3, 3), h = zeros(3, 3) and configuration
  #
  # -1  1  1
  #  1 -1  1
  #  1  1 -1
  #
  model = IsingPeriodic(3, 3, ones(3, 3), h=zeros(3, 3))
  for j=1:3
    model.sites[j, j] = -1.0
  end

  @test energy(model) ≈ 0.0

  #
  # J = ones(3, 3), h = ones(3, 3) and configuration
  #
  # -1  1  1
  #  1 -1  1
  #  1  1 -1
  #
  model = IsingPeriodic(3, 3, ones(3, 3), h=ones(3, 3))
  for j=1:3
    model.sites[j, j] = -1.0
  end

  @test energy(model) ≈ -3.0
end
