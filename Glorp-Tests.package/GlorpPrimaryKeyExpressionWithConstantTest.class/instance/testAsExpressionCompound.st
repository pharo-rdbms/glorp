tests
testAsExpressionCompound
	
	| e personTable |
	personTable := system tableNamed: 'PERSON'.

	e := compoundExpression asGeneralGlorpExpression.
	self assert: (e rightChild isKindOf: RelationExpression).
	self assert: (e rightChild relation == #=).
	self assert: (e rightChild leftChild isKindOf: FieldExpression).
	self assert: e rightChild leftChild field == (personTable fieldNamed: 'ADDRESS_ID').
	self assert: (e rightChild rightChild isKindOf: ConstantExpression).
	self assert: e rightChild rightChild value = 'B'.