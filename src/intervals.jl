#############################################################
# INTERVAL STRUCT
#############################################################
struct Interval{T<:Real}
    x1 :: T
    x2 :: T

    function Interval{T}(a::Real, b::Real) where T<:Real
        a == Inf && error("Infinity value x1")
        b == Inf && error("Infinity value x2")
        isnan(a) && error("NaN Value x1")
        isnan(b) && error("NaN Value x2")
        a > b && error("a>b")
        new(a, b)
    end
end

#############################################################
# BASIC FUNCTIONS
#############################################################
"""
Create Interval using previous struct
"""
Interval(a::T, b::T) where T<:Real = Interval{T}(a, b)
Interval(a::T) where T<:Real = Interval{T}(a, a)

"""
Print interval in a more friendly format
"""
function show(a::Interval)
    return [a.x1,a.x2]
end