tests
testSelfJoinWithPrimaryKeyExpression
	"This tests a join of a class to itself, in this case customers who have other customers associated with them. Useful for hierarchies"
	| pkExpression field result |
	field := (system tableNamed: 'GR_CUSTOMER') fieldNamed: 'ID'.
	pkExpression := Join 
		from: field
		to: field.
	result := self join: pkExpression.
	self assert: result leftChild basicField == field.
	self assert: result rightChild basicField == field.
	self assert: result rightChild base name = #relation.