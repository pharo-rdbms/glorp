instance creation
readManyOf: aClass where: anExpression limit: anInteger
	^self
		returningManyOf: aClass
		where: anExpression
		limit: anInteger