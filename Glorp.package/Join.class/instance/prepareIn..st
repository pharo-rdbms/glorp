preparing
prepareIn: aQuery 
	"Do nothing."
	aQuery whereClause: (self asGeneralGlorpExpression).
	aQuery whereClause prepareIn: aQuery.