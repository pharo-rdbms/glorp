instance creation
returningOneOf: aClass where: anExpression
	^self newQuery
		initResultClass: aClass
		whereClause: anExpression
		singleObject: true