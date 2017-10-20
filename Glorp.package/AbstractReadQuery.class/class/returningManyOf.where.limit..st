instance creation
returningManyOf: aClass where: anExpression limit: anInteger
	^(self newQuery)
		limit: anInteger;
		initResultClass: aClass
			whereClause: anExpression
			singleObject: false;
		yourself