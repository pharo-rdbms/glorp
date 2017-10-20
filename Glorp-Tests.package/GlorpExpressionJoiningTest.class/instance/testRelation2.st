tests
testRelation2
	| result exp field | 
	field := DatabaseField named: 'fred' type: system platform int4.
	exp := [:a | a foo = field] asGlorpExpressionOn: base.
	result := self join: exp. 
	self assert: result class == RelationExpression.
	self assert: result rightChild class == FieldExpression.
	self assert: result rightChild field == field.
	self assert: result leftChild base == source.