accessing
cachedQueryFor: aMapping is: aQuery
	"Save a query which we will use when constructing filtered queries"
	self queryCache at: aMapping put: aQuery