*Glorp
readOneOf: aClass where: aBlock
	^self new query: (Query readOneOf: aClass where: aBlock)