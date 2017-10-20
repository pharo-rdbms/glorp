As yet unclassified
testNotNullPrint

	| expression stream |
	expression := [:cust | cust id ~= nil]
		asGlorpExpressionForDescriptor: (system descriptorFor: GlorpCustomer).
	stream := DatabaseCommand new session: system session.
	expression printSQLOn: stream withParameters: Dictionary new.
	self assert: '(GR_CUSTOMER.ID IS NOT NULL)' equalsIgnoringOuterBrackets: stream contents.