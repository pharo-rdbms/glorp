preparing
addSingleOrderingForBuilder: aFieldExpression
	"Add the ordering to the query, as long as we don't already have an equivalent ordering there."	

	ordering isNil ifTrue: [^self orderBy: aFieldExpression].
	ordering 
		detect: [:eachExistingOrdering | 
			eachExistingOrdering = aFieldExpression 
				or: [eachExistingOrdering field = aFieldExpression field and: [eachExistingOrdering base = aFieldExpression base]]]
		ifNone: [self orderBy: aFieldExpression]