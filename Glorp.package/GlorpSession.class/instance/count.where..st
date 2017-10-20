api/queries
count: aClass where: anExpression
	^self execute: (SimpleQuery count: aClass where: anExpression)