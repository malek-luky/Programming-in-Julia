#############################################################
# INITIALIZATION
#############################################################
"""
* module: module name
* using: packages that we are using
* export: functions from our package
* include: functions from different files
"""
module IntervalArithmetic
export Interval, +, -, *, /
include("intervals.jl")
include("arithmetic.jl")
end # module




