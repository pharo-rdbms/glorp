preparing
allRelationsFor: rootExpression do: aBlock andBetweenDo: anotherBlock
	"We might have multiple clauses to print, depending on our mapping"
	self mapping 
		allRelationsFor: rootExpression
		do: aBlock
		andBetweenDo: anotherBlock.