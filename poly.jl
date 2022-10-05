###
#
# BI-JUL: 1. Domácí úkol v B221
#
# Podrobný popis zadání naleznete na Course pages nebo ve svém repozitáři.
#


#
# Typ `Polynomial{T}`
#


"""
Parametrický typ `Polynomial{T}`.
K vytvoření polynomu konstruktoru předáme pole:

    Polynomial([1, 2, 3])

Prvky v poly odpovídají koeficientům polynomu od nejnižšího stupně k největšímu.
Tj. volbě výše odpovídá polynom ``3x^2 + 2x + 1``.

Pole musí obsahovat alespoň jeden prvek, jinak nastane chyba.
Konstruktor správně určí stupeň zadaného polynomu (stupeň nulového polynomu
bereme jako ``-1``) a případně zahodí nepotřebné nulové koeficienty.
"""
struct Polynomial{ T <: Number }
  coefficients::Vector{T}
  degree::Int64

  function Polynomial(coefficients::Vector{T}) where { T <: Number }
    degree = length(coefficients) - 1

    if degree == -1
      throw(ArgumentError("You have to provide at least one coefficient!"))
    end

    while last(coefficients) == zero(T) && degree > 0
      pop!(coefficients)
      degree -= 1
    end

    if length(coefficients) == 1 && first(coefficients) == zero(T)
      degree = -1
    end

    return new{T}(coefficients, degree)
  end
end


#
# Porovnávání polynomů podle zvoleného datového typu.
#

import Base.==

function ==(p::Polynomial{T}, q::Polynomial{T}) where { T <: Number }
  # exact comparison
  p.coefficients == q.coefficients
end

function ==(p::Polynomial{T}, q::Polynomial{T}) where { T <: AbstractFloat }
  # approximate comparison
  p.coefficients ≈ q.coefficients
end


#
# Pěkná textová reprezentace polynomu.
#

"""
Ukázka výstupu:

    julia> Polynomial([1, 2, 3])
    + 3*x^2 + 2*x^1 + 1

    julia> Polynomial([1, 0, 3//2])
    + 3//2*x^2 + 1//1

    julia> Polynomial([1])
    1

    julia> Polynomial([0])
    0

"""
function Base.show(io::IO, p::Polynomial{T}) where { T <: Number }
  if p.degree <= 0
    return print(io, last(p.coefficients))
  end

  tokens = []

  for j in p.degree:-1:0
    c = p.coefficients[j + 1]

    if c < zero(T)
      append!(tokens, "- ", -c)
    elseif c > zero(T)
      append!(tokens, "+ ", c)
    end

    if j > 0 && c != zero(T)
      append!(tokens, "*x^", j, " ")
    end
  end

  print(io, tokens...)
end


#
# Algebraické operace `+` a `*`
#

import Base.*, Base.+

"""
Součin dvou polynomů.
"""
function *(p::Polynomial{T}, q::Polynomial{T}) where { T <: Number }
  # TODO

  return nothing
end

"""
Součet dvou polynomů.
"""
function +(p::Polynomial{T}, q::Polynomial{T}) where { T <: Number }
  # TODO

  return nothing
end


#
# Výpočet funkční hodnoty polynomu
#

"""
Díky této metodě můžeme polynomy vyhodnocovat, tedy počítat jejich funkční hodnoty.
Například:

    julia> p = Polynomial([1, 0, 3//2])
    + 3//2*x^2 + 1//1

    julia> p(-4//5)
    49//25

"""
function (p::Polynomial{T})(x::S) where { T <: Number, S <: Number }
  # TODO

  return nothing
end


#
# Dělení polynomu polynomem
#

"""
Divide polynomial `p` by polynomial `q` and return the quotient and remainder.
"""
function pdiv(p::Polynomial{T}, q::Polynomial{T}) where { T <: Number }
  if q.degree == -1
    throw(ArgumentError("It is not possible to divide by 0!"))
  end

  # TODO

  return nothing
end
