instance creation
read: aClass where: anExpression limit: anInteger
	^self
		returningManyOf: aClass
		where: anExpression
		limit: anInteger