api
getMapping: aMapping named: aSymbol
	"Suppose we do an expression of the form (x = aQuery) where the query returns an object of the same class as X. We want to rewrite that into a primary key comparison for the database, so we want to do a getMapping:named: against aQuery. But the only thing that seems to sensibly translate into is a retrieve: clause and return the query. That will only work for a single level get:, but I think that a multi-level one, from converting a block, shouldn't ever get to a general sub-select."
	query retrieve: aSymbol.