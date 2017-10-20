tests
testJoinOperation
	| userExpression base expression addressTable personTable query field1 field2 join |
	addressTable := system tableNamed: 'GR_ADDRESS'.
	personTable := system tableNamed: 'PERSON'.
	base := BaseExpression new.
	base descriptor: (system descriptorFor: GlorpPerson).
	userExpression := [:aPerson | aPerson address number = 12] 
				asGlorpExpressionOn: base.
	query := SimpleQuery readOneOf: GlorpPerson where: userExpression.
	query session: (GlorpSession new system: system).
	self assert: (userExpression additionalExpressionsIn: query) size = 1.
	query prepare.
	expression := query whereClause.
	self assert: query joins size = 1.
	join := query joins first.
	self
		assert: expression == userExpression;
		assert: expression relation == #=.
	field1 := join leftChild field.
	self assert: field1 table parent == personTable.
	self assert: field1 name = 'ADDRESS_ID'.
	field2 := join rightChild field.
	self assert: field2 table parent == addressTable.
	self assert: field2 name = 'ID'.