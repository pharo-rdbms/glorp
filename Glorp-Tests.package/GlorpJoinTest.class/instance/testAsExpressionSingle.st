tests
testAsExpressionSingle
	
	| e field param |
	e := expression asGeneralGlorpExpression.
	self assert: (e isKindOf: RelationExpression).
	self assert: e relation == #=.
	field := e leftChild.
	self assert: (field isKindOf: FieldExpression).
	self assert: field field == ((system tableNamed: 'CUSTOMER_ACCT_LINK') fieldNamed: 'ACCT_ID').
	param := e rightChild.
	self assert: (param isKindOf: ParameterExpression).
	self assert: param field == ((system tableNamed: 'BANK_ACCT') fieldNamed: 'ID').