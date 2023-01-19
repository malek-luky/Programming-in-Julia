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
function +(a::Interval, b)
    Interval(a.x1 + b, a.x2 + b)
end
"""
Addition (Number, Interval)
"""
+(b, a::Interval) = a+b

"""
Substratction (Interval,Number)
"""
function -(a::Interval, b)
    Interval(a.x1 - b, a.x2 - b)
end

"""
Substratction (Number,Interval)
"""
function -(b, a::Interval)
    Interval(b - a.x2, b - a.x1)
end

"""
Addition (Interval, Interval)
"""
function +(a::Interval, b::Interval)
    Interval(a.x1 + b.x1, a.x2 + b.x2)
end

"""
Substratction (Interval, Interval)
"""
function -(a::Interval, b::Interval)
    Interval(a.x1 - b.x2, a.x2 - b.x1)
end

#############################################################
# MULTIPLICATION AND DIVISION
#############################################################
"""
Multiplication (Number, Interval)
"""
function *(x, a::Interval)
    if x ≥ 0.0
        return Interval(a.x1*x, a.x2*x)
    else
        return Interval(a.x2*x, a.x1*x)
    end
end

"""
Multiplication (Interval, Number)
"""
*(a::Interval, x) = x*a

"""
Multiplication (Interval, Interval)
"""
function *(a::Interval, b::Interval)
    minimum = min(a.x1*b.x1, a.x1*b.x2,a.x2*b.x1,a.x2*b.x2)
    maximum = max(a.x1*b.x1, a.x1*b.x2,a.x2*b.x1,a.x2*b.x2)
    return Interval(minimum,maximum)
end

"""
Division (Interval, Number)
"""
function /(a::Interval, x)
    if x ≥ 0.0
        return Interval(a.x1/x, a.x2/x)
    else
        return Interval(a.x2/x, a.x1/x)
    end
end

"""
Inversion (Interval)
"""
function inv(a::Interval)
    Interval(inv(a.x2), inv(a.x1))
end

"""
Division (Interval, Interval)
"""
function /(a::Interval, b::Interval)
    a*inv(b)
end