printing SQL
allRelationsFor: rootExpression do: aBlock andBetweenDo: anotherBlock
	"Normal mappings just operate on a single expression"
	aBlock value: rootExpression leftChild value: rootExpression rightChild