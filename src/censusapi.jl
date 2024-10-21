module censusapi
using HTTP, JSON3, ExpandNestedData
using DataFrames, AnalysisUtils, CSV, Missings
export getcensus

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

end # module censusapi
