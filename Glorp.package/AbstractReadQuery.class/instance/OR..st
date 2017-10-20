boolean operations
OR: anExpression
	"Allow you to send AND: or OR: directly to a query to build up a query dynamically without needing to mess with the criteria explicitly"

	whereClause := (anExpression asGlorpExpressionOn: base)
		OR: (whereClause asGlorpExpressionOn: base) asGeneralGlorpExpression