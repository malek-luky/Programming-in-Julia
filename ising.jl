###
#
# BI-JUL: Domácí úkol č. 2
#
# Tomáš Kalvoda, 2022
#

"""
Monte Carlo simulace Isingova modelu.
"""
module Ising

# Balíčky používané vaším modulem:
using Images, ProgressMeter

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
struct IsingPeriodic <: IsingModel
  height::Int64
  width::Int64
  J::Matrix{Float64}
  β::Float64
  sites::Matrix{Float64} # Is this optimal?
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
  sites::Matrix{Float64} # Is this optimal?
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

  * `model`: Isingův model.
  * `max_steps`: maximální počet kroků (ve smyslu úspěšně změněných spinů), výchozí hodnota `1_000`.
  * `max_tries`: maximální počet neúspěšných pokusů o změnu hodnoty spinu, výchozí hodnota `1_00`.

Simulace probíhá podle Metropolisova algoritmu popsaného v `README.adoc`.
Pokusme se `max_steps`-krát změnit hodnotu některého ze spinů.
Pokud se náme `max_tries`-krát nepodaří hodnotu spinu změnit, tak jsme pravděpodobně blízko rovnovážného stavu a simulaci ukončujeme.
"""
function evolve!(model, max_steps=1_000, max_tries=1_00)
  # TODO
end


#
# Vizualizace
#

"""
Vizualizační metoda pro vykreslení spinů v mřížce (obdélníků).

NOTE: Vaše vizualizace nemusí nutně vypadat přesně tak jako moje v `ising.ipynb`. Nebojte se být kreativní.
"""
function plot(model)
  # TODO
end


#
# Pomocné metody
#

"""
Nastaví spiny zcela náhodně.
"""
function randomize!(model)
  # TODO
end

"""
Vrátí celkovou energii modelu v dané konfiguraci.
"""
function energy(model)
end

end # module
