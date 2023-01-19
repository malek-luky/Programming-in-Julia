import Base.show

#############################################################
# INTERVAL STRUCT
#############################################################
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
Create Interval using previous struct
"""
Interval(a::T, b::T) where T<:Number = Interval{T}(a, b)
Interval(a::T) where T<:Number = Interval{T}(a, a)

"""
Print interval in a more friendly format
"""
function show(io::IO,object::Interval)
    print(io,"[$(object.x1), $(object.x2)]")
end

