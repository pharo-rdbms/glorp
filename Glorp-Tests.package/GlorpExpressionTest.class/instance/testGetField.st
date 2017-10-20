tests
testGetField
	| expression |
	expression := [:cust | cust getField: 'ID'] asGlorpExpressionForDescriptor: (system descriptorFor: GlorpCustomer).
	self assert: expression sqlString = 'GR_CUSTOMER.ID'.
	self assert: expression class = FieldExpression.
	self assert: expression field table = (system tableNamed: 'GR_CUSTOMER').