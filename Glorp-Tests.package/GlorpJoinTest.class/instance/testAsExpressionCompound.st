tests
testAsExpressionCompound
	
	| e personTable accountTable |
	personTable := system tableNamed: 'PERSON'.
	accountTable := system tableNamed: 'BANK_ACCT'.

	e := compoundExpression asGeneralGlorpExpression.
	self assert: (e isKindOf: RelationExpression).
	self assert: e relation == #AND.
	self assert: (e leftChild isKindOf: RelationExpression).
	self assert: (e leftChild relation == #=).
	self assert: (e leftChild leftChild isKindOf: FieldExpression).
	self assert: e leftChild leftChild field == (personTable fieldNamed: 'NAME').
	self assert: (e leftChild rightChild isKindOf: ParameterExpression).
	self assert: e leftChild rightChild field == (accountTable fieldNamed: 'ID').


	self assert: (e rightChild isKindOf: RelationExpression).
	self assert: (e rightChild relation == #=).
	self assert: (e rightChild leftChild isKindOf: FieldExpression).
	self assert: e rightChild leftChild field == (personTable fieldNamed: 'ADDRESS_ID').
	self assert: (e rightChild rightChild isKindOf: ParameterExpression).
	self assert: e rightChild rightChild field = (accountTable fieldNamed: 'BANK_CODE').