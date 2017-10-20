preparing
allRelationsFor: rootExpression do: aBlock andBetweenDo: anotherBlock
	"In any normal relationship, there's only one thing. Just do it"
	aBlock value: rootExpression leftChild value: rootExpression rightChild.