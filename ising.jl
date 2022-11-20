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
∑(v) = +(v...) # definice sumy (funguje stejně jako sum(), čitelnější, fajn na vyzkoušení čeho je Julie schopná)

"""
Isingův model s periodickými okrajovými podmínkami.

Konstruktor očekává rozměry obdélníku `height` a `width` a inicializuje všechny spiny do stavu `+1`.

Dále lze předat `3x3` matici `J` popisující interakci mezi sousedy.
Výchozí volba je matice plná jedniček, což odpovídá feromagnetické interakci a žádný ze sousedů není preferován.
Matice by měla být "symetrická" vůči zrcadlení vzhledem ke všem osám symetrie čtverce, jinak model nebude mít dobrý fyzikální význam (interakce by závisela na pořadí, v kterém spiny interagují, což nedává příliš smysl).

Konečně lze předat inverzní teplotu (`β`, výchozí hodnota `1.0`) nebo vnější magnetické pole (`h`, ve výchozím stavu vypnuto, tedy všechny jeho prvky jsou nulové).
"""
struct IsingPeriodic <: IsingModel
  height::Int64
  width::Int64
  J::Matrix{Float64}
  β::Float64
  sites::Matrix{Int8}
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
struct IsingFixed <: IsingModel
  height::Int64
  width::Int64
  J::Matrix{Float64}
  β::Float64
  sites::Matrix{Int8}
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


################################################
####### VIZUALIZACE
################################################

"""
Vizualizační metoda pro vykreslení spinů v mřížce (obdélníků).
NOTE: Vaše vizualizace nemusí nutně vypadat přesně tak jako moje v `ising.ipynb`. Nebojte se být kreativní.
"""
function plot(model)
  heatmap(model.sites, aspect_ratio=:equal, color=:grays, legend=false, xaxis=false, yaxis=false, grid=false, framestyle=:box, title="Ising model")
end

################################################
####### NÁHODNÉ NASTAVENÍ SPINŮ
################################################

"""
Nastaví spiny zcela náhodně.
"""
function randomize!(model::IsingPeriodic)
  model.sites[1:end, 1:end] = rand([-1, 1], model.width, model.height)
end

function randomize!(model::IsingFixed)
  model.sites[2:end-1, 2:end-1] = rand([-1, 1], model.width - 2, model.height - 2)
end

################################################
####### ČASOVÝ VÝVOJ
################################################
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
  steps = 0
  tries = 0
  σ = [append(model)[i, :] for i in 1:model.height+2]
  J = [model.J[i, :] for i in 1:3]

  while steps < max_steps && tries < max_tries
    # Pick random site
    print("Steps: $steps, tries: $tries\r")
    x = rand(2:model.width+1) # jiné rozměry kvůli appendu
    y = rand(2:model.height+1)
    i = (y-2) * model.width + (x-1) # index pro matici bez appendu

    # Calculate energy change
    H = energy_neigbors(σ, J, x, y) + model.h[i] * model.sites[i]
    model.sites[i] = -model.sites[i]
    σ[x][y] = -σ[x][y]
    new_H = energy_neigbors(σ, J, x, y) + model.h[i] * model.sites[i]
    ΔH = new_H - H

    # Decide whether to accept the change
    if ΔH <= 0 || rand() <= exp(-model.β * ΔH) # sites are already switched
      steps += 1
      tries = 0
    else
      model.sites[i] = -model.sites[i] #revert
      σ[x][y] = -σ[x][y] #revert
      tries += 1
    end
  end
end


################################################
####### VÝPOČET ENERGIE
################################################

"""
Pomocná funkce - Přidaní okrajů
Abychom nemuseli řešit pomocí ifů při výpočtech zda se jedná o Periodic či Fixed model, vytvoříme zde na základě jeho typu patříčny "okraj"

* Fixed - doplníme na okraj nuly nuly, tudíž nebude problém s indexací, a můžeme použít stejný kód pro výpočet energie
* Periodic - doplníme na okraj hodnoty z opračné strany matrixu pro vytvoření dojmu plochého torusu
"""
function append(model::IsingPeriodic)
  new_m = zeros(model.width + 2, model.height + 2)
  new_m[2:end-1, 2:end-1] = model.sites
  new_m[1, 2:end-1] = model.sites[end, :]
  new_m[end, 2:end-1] = model.sites[1, :]
  new_m[2:end-1, 1] = model.sites[:, end]
  new_m[2:end-1, end] = model.sites[:, 1]
  new_m[1, 1] = model.sites[end, end]
  new_m[1, end] = model.sites[end, 1]
  new_m[end, 1] = model.sites[1, end]
  new_m[end, end] = model.sites[1, 1]
  new_m
end
function append(model::IsingFixed)
  new_m = zeros(model.width + 2, model.height + 2)
  new_m[2:end-1, 2:end-1] = model.sites
  new_m
end

"""
Vypočítání energie první sumy všech možných sousedů (celkem 20 - možnosti viz pull request)
J = Míra iterakce mezi i-tym a j-tym spinem
σ = orientace spinu
width = šířka mřížky
height = výška mřížky

STEPS:
1) rozšířit okraje na základě modelu (fixed doplní nuly, periodic "prekopiruje" okraje)
2) Předělání matice pro přehlednější použití [i][j] indexingu (#TODO: příště se držet klasických indexů, toto není to vhodné)
3) iterujeme pres všechny spinu a vypočítáme energii pro každý spin (první suma za vzorce)
4) Uprostřed for loopu spočítame sumu přes 4 sousedy vpravo dole (pouze 4, aby se neduplikovali - každý sousem má být pouze 1x)
"""
function energy_neigbors(σ, J, x, y)
  ∑(J[-dj+2][di+2] * σ[x+di][y+dj] * σ[x][y] for (di, dj) in [[-1, -1], [0, -1], [1, -1], [1, 0]])
end

"""
Vrátí celkovou energii modelu v dané konfiguraci.
model = Ising.fixed nebo Ising.periodic
model format = height, width, J, β, sites, h

STEPS:
1) První suma ze vzorce se spočítá v rámci energy_neigbors
2) Druhá suma viz níže
"""
function energy(model)
  σ = [append(model)[i, :] for i in 1:model.height+2]
  J = [model.J[i, :] for i in 1:3]
  result = 0
  for x in 2:model.width+1
    for y in 2:model.height+1
      result -= energy_neigbors(σ, J, x, y)
    end
  end
  result -= ∑(model.h[i] * model.sites[i] for i in 1:model.height*model.width) # druhá suma
end

end # module
