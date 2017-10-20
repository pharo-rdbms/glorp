As yet unclassified
testIsNullPrint

	| expression stream |
	expression := [:cust | cust id = nil]
		asGlorpExpressionForDescriptor: (system descriptorFor: GlorpCustomer).
	stream := DatabaseCommand new session: system session.
	expression printSQLOn: stream withParameters: Dictionary new.
	self assert: '(GR_CUSTOMER.ID IS NULL)' equalsIgnoringOuterBrackets: expression sqlString.