# BI-JUL: 1. Domácí úkol v B221
#
# Podrobný popis zadání naleznete na Course pages nebo ve svém repozitáři.
# 10.7.2022
# Lukáš Málek


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
struct Polynomial{T<:Number}
  coefficients::Vector{T}
  degree::Int64

  function Polynomial(coefficients::Vector{T}) where {T<:Number}
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


"""
Porovnávání polynomů podle zvoleného datového typu.
"""

import Base.==

function ==(p::Polynomial{T}, q::Polynomial{T}) where {T<:Number}
  # exact comparison
  p.coefficients == q.coefficients
end

function ==(p::Polynomial{T}, q::Polynomial{T}) where {T<:AbstractFloat}
  # approximate comparison
  p.coefficients ≈ q.coefficients
end


"""
Textová reprezentace, ukázka výstupu:

    julia> Polynomial([1, 2, 3])
    + 3*x^2 + 2*x^1 + 1

    julia> Polynomial([1, 0, 3//2])
    + 3//2*x^2 + 1//1

    julia> Polynomial([1])
    1

    julia> Polynomial([0])
    0

"""
function Base.show(io::IO, p::Polynomial{T}) where {T<:Number}
  if p.degree <= 0
    return print(io, last(p.coefficients))
  end

  tokens = []

  for j in p.degree:-1:0
    c = p.coefficients[j+1]

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


"""
TASK1: Součin dvou polynomů
"""

import Base.*, Base.+, Base.-

function *(p::Polynomial{T}, q::Polynomial{T}) where {T<:Number}
  coefficients = zeros(T, p.degree + q.degree + 1)
  index = 0
  for value in p.coefficients
    for value2 in q.coefficients
      index += 1
      coefficients[index] += value * value2
    end
    index -= q.degree
  end
  return Polynomial(coefficients)
end


"""
TASK2: Součet dvou polynomů.
"""
function +(p::Polynomial{T}, q::Polynomial{T}) where {T<:Number}
  coefficients = zeros(T, max(p.degree, q.degree) + 1)
  for (index, value) in enumerate(p.coefficients)
    coefficients[index] += value
  end
  for (index, value) in enumerate(q.coefficients)
    coefficients[index] += value
  end
  return Polynomial(coefficients)
end

"""
EXTRA TASK: Odečet dvou polynomů.
"""
function -(p::Polynomial{T}, q::Polynomial{T}) where {T<:Number}
  coefficients = zeros(T, max(p.degree, q.degree) + 1)
  for (index, value) in enumerate(p.coefficients)
    coefficients[index] += value
  end
  for (index, value) in enumerate(q.coefficients)
    coefficients[index] -= value
  end
  return Polynomial(coefficients)
end


"""
Díky této metodě můžeme polynomy vyhodnocovat, tedy počítat jejich funkční hodnoty.
Například:

    julia> p = Polynomial([1, 0, 3//2])
    + 3//2*x^2 + 1//1

    julia> p(-4//5)
    49//25

"""
function (p::Polynomial{T})(x::S) where {T<:Number,S<:Number}
  result = zero(T)
  x_pow = 1 / x
  for value in p.coefficients
    x_pow *= x
    result += value * x_pow
  end
  return result
end


"""
TASK3: Divide polynomial `p` by polynomial `q` and return the quotient and remainder.
"""
Base.deepcopy(s::Polynomial) = Polynomial(s.coefficients)
import Base.copy

function pdiv(p::Polynomial{T}, q::Polynomial{T}) where {T<:Number}
  if q.degree == -1
    throw(ArgumentError("It is not possible to divide by 0!"))
  else
    remainder = deepcopy(p)
    quotient = zeros(T,max(p.degree - q.degree + 1, 1))
    while remainder.degree >= q.degree
      index = remainder.degree - q.degree + 1
      value = convert(T,remainder.coefficients[end]/ q.coefficients[end])
      quotient[index] = value
      deg = remainder.degree - q.degree
      result = q.coefficients * value
      remainder -= Polynomial([zeros(T,deg); result])
    end
    return Polynomial(quotient), remainder
  end
end