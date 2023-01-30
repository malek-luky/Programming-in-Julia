#############################################################
# IMPORTS
#############################################################
import Base: !=,==,+, -, *, /, >, <, inv, min, max

#############################################################
# COMPARISON
#############################################################
"""
    ==(a::Interval, b::Interval)
Checks if the intervals `a` and `b` are equal.
"""
function ==(a::Interval, b::Interval)
    a.x1 == b.x1 && a.x2 == b.x2
end

"""
    !=(a::Interval, b::Interval)
Checks if the intervals `a` and `b` are not equal.
"""
!=(a::Interval, b::Interval) = !(a==b)

"""
    <(a::Interval, b::Interval)
Compare if `a` < `b`.
"""
function <(a::Interval, b::Interval)
    abs(a.x1-a.x2)<abs(b.x1-b.x2)
end

"""
    >(a::Interval, b::Interval)
Compare if `a` > `b`.
"""
function >(a::Interval, b::Interval)
    abs(a.x1-a.x2)>abs(b.x1-b.x2)
end


#############################################################
# ADDITION AND SUBSTRACTION
#############################################################
"""
    +(a::Interval)
Interval does not change
"""
+(a::Interval) = a

"""
    -(a::Interval)
Changes the Interval to negative values
"""
-(a::Interval) = Interval(-a.x2, -a.x1)

"""
    +(a::Interval, b)
Addition (Interval,Number)
"""
function +(a::Interval, b)
    Interval(a.x1 + b, a.x2 + b)
end
"""
    +(b, a::Interval)
Addition (Number, Interval)
"""
+(b, a::Interval) = a+b

"""
    -(a::Interval, b)
Substratction (Interval,Number)
"""
function -(a::Interval, b)
    Interval(a.x1 - b, a.x2 - b)
end

"""
    -(b, a::Interval)
Substratction (Number,Interval)
"""
function -(b, a::Interval)
    Interval(b - a.x2, b - a.x1)
end

"""
    +(a::Interval, b::Interval)
Addition (Interval, Interval)
"""
function +(a::Interval, b::Interval)
    Interval(a.x1 + b.x1, a.x2 + b.x2)
end

"""
    -(a::Interval, b::Interval)
Substratction (Interval, Interval)
"""
function -(a::Interval, b::Interval)
    Interval(a.x1 - b.x2, a.x2 - b.x1)
end

#############################################################
# MULTIPLICATION AND DIVISION
#############################################################
"""
    *(x, a::Interval)
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
    *(a::Interval, x)
Multiplication (Interval, Number)
"""
*(a::Interval, x) = x*a

"""
    *(a::Interval, b::Interval)
Multiplication (Interval, Interval)
"""
function *(a::Interval, b::Interval)
    minimum = min(a.x1*b.x1, a.x1*b.x2,a.x2*b.x1,a.x2*b.x2)
    maximum = max(a.x1*b.x1, a.x1*b.x2,a.x2*b.x1,a.x2*b.x2)
    return Interval(minimum,maximum)
end

"""
    /(a::Interval, x)
Division (Interval, Number)
"""
function /(a::Interval, x)
    if x==0
        error("Division by zero")
    elseif x > 0.0
        return Interval(a.x1/x, a.x2/x)
    else
        return Interval(a.x2/x, a.x1/x)
    end
end

"""
    inv(a::Interval)
Inversion (Interval)
"""
function inv(a::Interval)
    Interval(inv(a.x2), inv(a.x1))
end

"""
    /(a::Interval, b::Interval)
Division (Interval, Interval)
"""
function /(a::Interval, b::Interval)
    if (b.x1<=0 && b.x2>=0)
        error("Division by Interval with zero")
    else 
        return a*inv(b)
    end
end