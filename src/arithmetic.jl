#############################################################
# IMPORTS
#############################################################
import Base: !=,==,+, -, *, /, inv, min, max

#############################################################
# COMPARISON
#############################################################
"""
Checks if the intervals `a` and `b` are equal.
"""
function ==(a::Interval, b::Interval)
    a.x1 == b.x1 && a.x2 == b.x2
end

"""
Checks if the intervals `a` and `b` are not equal.
"""
!=(a::Interval, b::Interval) = !(a==b)


#############################################################
# ADDITION AND SUBSTRACTION
#############################################################
"""
Changing the signs infront of the Interval
"""
+(a::Interval) = a
-(a::Interval) = Interval(-a.x2, -a.x1)

"""
Addition (Interval,Number)
"""
function +(a::Interval{T}, b::T) where {T<:Real}
    Interval(a.x1 + b, a.x2 + b)
end
"""
Addition (Number, Interval)
"""
+(b::T, a::Interval{T}) where {T<:Real} = a+b

"""
Substratction (Interval,Number)
"""
function -(a::Interval{T}, b::T) where {T<:Real}
    Interval(a.x1 - b, a.x2 - b)
end

"""
Substratction (Number,Interval)
"""
function -(b::T, a::Interval{T}) where {T<:Real}
    Interval(b - a.x2, b - a.x1)
end

"""
Addition (Interval, Interval)
"""
function +(a::Interval{T}, b::Interval{T}) where T<:Real
    Interval(a.x1 + b.x1, a.x2 + b.x2)
end

"""
Substratction (Interval, Interval)
"""
function -(a::Interval{T}, b::Interval{T}) where T<:Real
    Interval(a.x1 - b.x2, a.x2 - b.x1)
end

#############################################################
# MULTIPLICATION AND DIVISION
#############################################################
"""
Multiplication (Number, Interval)
"""
function *(x::T, a::Interval{T}) where {T<:Real}
    if x ≥ 0.0
        return Interval(a.x1*x, a.x2*x)
    else
        return Interval(a.x2*x, a.x1*x)
    end
end

"""
Multiplication (Interval, Number)
"""
*(a::Interval{T}, x::T) where {T<:Real} = x*a

"""
Multiplication (Interval, Interval)
"""
function *(a::Interval{T}, b::Interval{T}) where T<:Real
    minimum = min(a.x1*b.x1, a.x1*b.x2,a.x2*b.x1,a.x2*b.x2)
    maximum = max(a.x1*b.x1, a.x1*b.x2,a.x2*b.x1,a.x2*b.x2)
    return Interval(minimum,maximum)
end

"""
Division (Interval, Number)
"""
function /(a::Interval{T}, x::T) where {T<:Real}
    if x ≥ 0.0
        return Interval(a.x1/x, a.x2/x)
    else
        return Interval(a.x2/x, a.x1/x)
    end
end

"""
Inversion (Interval)
"""
function inv(a::Interval{T}) where T<:Real
    if (a.x1<0 && a.x2>0)
        Interval(inv(a.x1), inv(a.x2))
    else
        Interval(inv(a.x2), inv(a.x1))
    end
end

"""
Division (Interval, Interval)
"""
function /(a::Interval{T}, b::Interval{T}) where T<:Real
    Interval(Float64(a.x1),Float64(a.x2))*inv(b)
end