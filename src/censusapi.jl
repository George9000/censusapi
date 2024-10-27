module censusapi
using HTTP, JSON3, ExpandNestedData
using DataFrames, AnalysisUtils, CSV, Missings
export getcensus, flowdf

"""
    getcensus(dataseturl, query, datafilepath)

Query the US Census api.
Arguments:
dataseturl, string, subpath to append to base url; no trailing slash
query, Vector{Pair}, query as a vector of key => value string pairs
"""
function getcensus(dataseturl, query, datafilepath)
    io = open(datafilepath, "w")
    response = HTTP.get("https://api.census.gov/data/"*dataseturl, query = query, response_stream = io)
    close(io)
    print(response.status)
end

"""
    flowdf(filename::String)

Construct a census flows dataframe
from the textfile returned by the getcensus function.
"""
function flowdf(filename::String)
    strexpr = read(filename, String)
    strexpr = replace(strexpr, r"\"" => "", "[" => "", "]," => "", "]]" => "", "\\u00F1" => "ñ")
    df = CSV.read(IOBuffer(strexpr), DataFrame; missingstring = "null")
end
# vec = eval(Meta.parse(strexpr))
# return DataFrame(Tuple.(vec[2:end]), vec[1])

end # module censusapi
