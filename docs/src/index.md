# IntervalArithmetics.jl Documentation
* Contact: malek.luky@gmail.com

## IntervalArithmetics Module
* Functions from intervals.jl file
```@docs
Interval{T<:Number}
Interval(a::T, b::T) where T<:Number
Interval(a::T) where T<:Number
```

## Expanding Base Module functions
* Functions from arithmetics.jl file
* Expanded usage of Base Module
* Added new input arguments with Interval struct from this Module

### Comparison
```@docs
==(a::Interval, b::Interval)
!=(a::Interval, b::Interval)
<(a::Interval, b::Interval)
>(a::Interval, b::Interval)
```

### Addition and Substraction
```@docs
+(a::Interval)
-(a::Interval)
+(a::Interval, b)
+(b, a::Interval)
-(a::Interval, b)
-(b, a::Interval)
+(a::Interval, b::Interval)
-(a::Interval, b::Interval)
```

### Multiplication and division
``` @docs
*(x, a::Interval)
*(a::Interval, x)
*(a::Interval, b::Interval)
/(a::Interval, x)
inv(a::Interval)
/(a::Interval, b::Interval)
```