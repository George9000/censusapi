using censusapi
# remember to enter in the terminal session only: 
# const censustoken = key_as_string_here

# example query
getcensus("2022/acs/flows", ["get" => "STATE1,STATE1_NAME,FULL1_NAME,FULL2_NAME,GEOID1,GEOID2,MOVEDIN,NONMOVERS,POP1YRAGO,POP1YR",
                             "for" => "county:*", "in" => "state:*", "key" => "$censustoken"], "2022_flows.txt")

const flows = flowdf("2022_flows.txt")

#=
names(flows)
12-element Vector{String}:
 "STATE1"
 "STATE1_NAME"
 "FULL1_NAME"
 "FULL2_NAME"
 "GEOID1"
 "GEOID2"
 "MOVEDIN"
 "NONMOVERS"
 "POP1YRAGO"
 "POP1YR"
 "state"
 "county"
=#

## Which state has the largest percentage
## of its population moving out?

@chain flows begin
    groupby([:GEOID2, :FULL2_NAME])
    combine([:MOVEDIN, :POP1YRAGO] => ((m, p) -> sum(m) ./ unique(skipmissing(p)))
            => :percentageout, :MOVEDIN => sum => :sum_moves)
    transform(:percentageout => (p -> round.(100 .* p, digits = 2)), renamecols = false)
    sort(:percentageout, rev = true)
    show(allrows = true)
end

# Why is the broadcast needed for the anonymous function?
# Because of this error
# => MethodError: no method matching /(::Int64, ::Vector{Int64})
#  unique(itr) Returns an array containing only the unique elements of collection itr
# while...
# sum() The return type is Int or  a common return type is
# found to which all arguments are promoted.

# typeof unique pop1yrago
@chain flows begin
    groupby([:GEOID2, :FULL2_NAME])
    combine(:POP1YRAGO => (p -> typeof(unique(skipmissing(p)))) => :upop1yrago)
    sort(:GEOID2, rev = true)
    show(allrows = true)
end

@chain flows begin
    groupby([:GEOID2, :FULL2_NAME])
    combine(:MOVEDIN => (m -> typeof(sum(m))) => :sum_moves_type)
end

@chain flows begin
    groupby([:GEOID2, :FULL2_NAME])
    combine(:POP1YRAGO => (p -> unique(skipmissing(p))) => :upop1yrago)
    sort(:GEOID2, rev = true)
    show(allrows = true)
end
