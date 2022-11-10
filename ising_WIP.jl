###
#
# BI-JUL: Domácí úkol č. 2
#
# Tomáš Kalvoda, 2022
#

"""
Monte Carlo simulace Isingova modelu.
"""
module Ising # start module

# Balíčky používané vaším modulem:
using Images, ProgressMeter, Plots

# Veřejné metody, přístupné uživateli.
export IsingPeriodic, IsingFixed
export plot, evolve!, randomize!, energy

#
# Typy
#

abstract type IsingModel end

"""
Isingův model s periodickými okrajovými podmínkami.

Konstruktor očekává rozměry obdélníku `height` a `width` a inicializuje všechny spiny do stavu `+1`.

Dále lze předat `3x3` matici `J` popisující interakci mezi sousedy.
Výchozí volba je matice plná jedniček, což odpovídá feromagnetické interakci a žádný ze sousedů není preferován.
Matice by měla být "symetrická" vůči zrcadlení vzhledem ke všem osám symetrie čtverce, jinak model nebude mít dobrý fyzikální význam (interakce by závisela na pořadí, v kterém spiny interagují, což nedává příliš smysl).

Konečně lze předat inverzní teplotu (`β`, výchozí hodnota `1.0`) nebo vnější magnetické pole (`h`, ve výchozím stavu vypnuto, tedy všechny jeho prvky jsou nulové).
"""
mutable struct IsingPeriodic <: IsingModel
  height::Int64
  width::Int64
  J::Matrix{Float64}
  β::Float64
  sites::Matrix{Int8} # Is this optimal? No, we know it has only 1 or -1, Int8 is sufficient
  h::Matrix{Float64}

  function IsingPeriodic(height, width, J=ones(3, 3); β=1.0, h=zeros(height, width))
    if β <= 0
      throw(ArgumentError("β has to be positive!"))
    end

    if size(J) != (3, 3)
      throw(ArgumentError("J has to be 3x3 matrix!"))
    end

    sites = ones(height, width)

    if size(sites) != size(h)
      throw(ArgumentError("Sizes of sites and h has to match!"))
    end

    new(height, width, J, β, sites, h)
  end
end

"""
Isingův model s pevnými okrajovými podmínkami.

Konstruktor očekává matici s rozměry `height × width`, kde spiny na okraji chápe jako hraniční a neměnné.
Během vývoje se mění jenom ty, co nejsou v prvním a posledním řádku a sloupci matice.

Dále lze předat `3x3` matici `J` popisující interakci mezi sousedy.
Výchozí volba je matice plná jedniček, což odpovídá feromagnetické interakci a žádný ze sousedů není preferován.
Matice by měla být "symetrická" vůči zrcadlení vzhledem ke všem osám symetrie čtverce, jinak model nebude mít dobrý fyzikální význam (interakce by závisela na pořadí).

Konečně lze předat inverzní teplotu (`β`, výchozí hodnota `1.0`) nebo vnější magnetické pole (`h`, ve výchozím stavu vypnuto, tedy všechny jeho prvky jsou nulové).

"""
mutable struct IsingFixed <: IsingModel
  height::Int64
  width::Int64
  J::Matrix{Float64}
  β::Float64
  sites::Matrix{Int8} # Is this optimal? No, we know it has only 1 or -1, Int8 is sufficient
  h::Matrix{Float64}

  function IsingFixed(sites, J=ones(3, 3); β=1.0, h=zeros(size(sites)))
    height, width = size(sites)

    if β <= 0
      throw(ArgumentError("β has to be positive!"))
    end

    if size(J) != (3, 3)
      throw(ArgumentError("J has to be 3x3 matrix!"))
    end

    if size(sites) != size(h)
      throw(ArgumentError("Sizes of sites and h has to match!"))
    end

    new(height, width, J, β, sites, h)
  end
end


#
# Časový vývoj
#

"""
Spustí simulaci Isingova modelu.
Na vstupu popořadě očekává:

  * `model`: Ising.fixed or Ising.periodic
  * `model format` = height, width, J, β, sites, h 
  * `max_steps`: maximální počet kroků (ve smyslu úspěšně změněných spinů), výchozí hodnota `1_000`.
  * `max_tries`: maximální počet neúspěšných pokusů o změnu hodnoty spinu, výchozí hodnota `1_00`.

Simulace probíhá podle Metropolisova algoritmu popsaného v `README.adoc`.
Pokusme se `max_steps`-krát změnit hodnotu některého ze spinů.
Pokud se náme `max_tries`-krát nepodaří hodnotu spinu změnit, tak jsme pravděpodobně blízko rovnovážného stavu a simulaci ukončujeme.
"""
function evolve!(model, max_steps=1000, max_tries=100)
  format(model)
  steps = 0
  tries = 0

  while steps < max_steps && tries < max_tries
    # Pick random site
    print("Steps: $steps, tries: $tries\r")
    i = rand(1:model.width*model.height)

    # Calculate energy change
    H = energy(model)
    model.sites[i] = -model.sites[i]
    new_H =  energy(model) # avoid deepcopy
    ΔH = new_H - H

    # Decide whether to accept the change
    if ΔH <= 0 || rand() <= exp(-model.β * ΔH)
      # if true model.sites are already switched
      steps += 1
      tries = 0
    else
      model.sites[i] = -model.sites[i] # switch back
      tries += 1
    end
  end
end


#
# Vizualizace
#

"""
Vizualizační metoda pro vykreslení spinů v mřížce (obdélníků).
NOTE: Vaše vizualizace nemusí nutně vypadat přesně tak jako moje v `ising.ipynb`. Nebojte se být kreativní.
"""
function plot(model)
  heatmap(model.sites, aspect_ratio=:equal, color=:grays, legend=false,xaxis=false,yaxis=false, grid=false, framestyle=:box, title="Ising model") 
end


#
# Pomocné metody
#

"""
Přidaní okrajů
m = matrix, which we want to add zero border to

STEPS:
1) if Ising.fixed add zeros everywhere
2) if Ising.periodic add first and last row and columm
  +add the same to the diagonal (its best to draw it)
"""
function append(m, model)
  if typeof(model) == IsingFixed
    new_m = zeros(model.width + 2, model.height + 2)
    new_m[2:end-1, 2:end-1] = m
    new_m
  elseif typeof(model) == IsingPeriodic
    new_m = zeros(model.width + 2, model.height + 2)
    new_m[2:end-1, 2:end-1] = m
    new_m[1, 2:end-1] = m[end, :]
    new_m[end, 2:end-1] = m[1, :]
    new_m[2:end-1, 1] = m[:, end]
    new_m[2:end-1, end] = m[:, 1]
    new_m[1, 1] = m[end, end]
    new_m[1, end] = m[end, 1]
    new_m[end, 1] = m[1, end]
    new_m[end, end] = m[1, 1]
    new_m
  else
    throw(ArgumentError("Model has to be Ising.fixed or Ising.periodic!"))
  end
end

"""
Preformatuje model
Preformatovani modelu z matrixu na 2D array
Umozni pristupovat ve 2D indexech (matrix[i][j])
Mutable - we edit directly the model
"""
function format(model)
  model.sites = [append(model.sites, model)[i, :] for i in 1:model.width+2]
  model.J = [model.J[i, :] for i in 1:3]
  model.h = [model.h[i, :] for i in 1:model.width+2]
end

"""
Nastaví spiny zcela náhodně.
"""
function randomize!(model)
  if typeof(model) == IsingFixed
    model.sites[2:end-1, 2:end-1] = rand([-1, 1], model.width - 2, model.height - 2)
  elseif typeof(model) == IsingPeriodic
    model.sites = rand([-1, 1], model.width, model.height)
  else
    throw(ArgumentError("Model has to be Ising.fixed or Ising.periodic!"))
  end
end

"""
Vrátí celkovou energii modelu v dané konfiguraci.
model = Ising.fixed or Ising.periodic (mutable - lze měnit i z funkcí)
model format = height, width, J, β, sites, h

STEPS:
1) append the matrices with zeros so we wont have to check the boundaries
2) change matrix to 2D array (so that we can use [i][j] indexing)
3) iterate over all possible sites (=sigmas) on indexes i,j
4) for each site check neibours (using J) on right bottom (only 4 indexes instead of 8 so we wont check one neigbour twice)
5) compute the final sum using the formula
"""
∑(v) = +(v...) # definice sumy (funguje stejně jako sum(), jen je čitelnější)
function energy(model)
  # σ = model.sites
  # J = model.J
  if model.height == length(model.sites) && model.width == length(model.sites[1])
    format(model)
  end
  -∑(model.J[-dj+2][di+2] * model.sites[i+di][j+dj] * model.sites[i][j] for i in 2:model.width+1, j in 2:model.height+1, (di, dj) in [[-1, -1], [0, -1], [1, -1], [1, 0]]) - ∑(model.h[i][j] * model.sites[i+1][j+1] for i in 1:model.width, j in 1:model.height)
  #model je změněn uvnitř funkce
end

end # module
