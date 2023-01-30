import Base.show

#############################################################
# INTERVAL STRUCT
#############################################################
"""
    Interval{T<:Number}
Struct that holds all necessary informatino about the Interval
"""
struct Interval{T<:Number}
    x1 :: T
    x2 :: T

    function Interval{T}(a::Number, b::Number) where T<:Real
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
    Interval(a::T, b::T)
Create Interval using Interval struct
"""
Interval(a::T, b::T) where T<:Number = Interval{T}(a, b)

"""
    Interval(a::T)
Create Interval with only single value
"""
Interval(a::T) where T<:Number = Interval{T}(a, a)

"""
    show(io::IO,object::Interval)
Print interval in a more readable format
"""
function show(io::IO,object::Interval)
    print(io,"[$(object.x1), $(object.x2)]")
end

