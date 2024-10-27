using censusapi
# remember to enter in the terminal session only: 
# const censustoken = key_as_string_here

# example query
getcensus("2022/acs/flows", ["get" => "STATE1,STATE1_NAME,FULL1_NAME,FULL2_NAME,GEOID1,GEOID2,MOVEDIN,NONMOVERS,POP1YRAGO,POP1YR", "for" => "county:*", "in" => "state:*", "key" => "$censustoken"], "2022_flows.txt")

const flows = flowdf("2022_flows.txt")
