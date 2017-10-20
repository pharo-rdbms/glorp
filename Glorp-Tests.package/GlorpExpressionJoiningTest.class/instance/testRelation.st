tests
testRelation
	| result exp |
	exp := [:a | a foo = 3] asGlorpExpressionOn: base.
	result := self join: exp. 

	self assert: result class == RelationExpression.
	self assert: result rightChild == exp rightChild.
	self assert: result leftChild base == source.