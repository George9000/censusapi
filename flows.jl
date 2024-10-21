using censusapi
# remember to enter in the terminal session only: 
# const censustoken = key_as_string_here

# example query
getcensus("2022/acs/flows", ["get" => "FULL1_NAME,FULL2_NAME,GEOID1,GEOID2,MOVEDIN", "for" => "county:*", "in" => "state:*", "key" => "$censustoken"], "2022_migration_flows.txt")
