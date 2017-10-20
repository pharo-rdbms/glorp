tests
testAnySatisfyPrintJoin
	| expression |
	system useJoinsForAnySatisfy: true.
	expression := [:cust | cust transactions anySatisfy: [:each | each id = 7]] 
				asGlorpExpressionForDescriptor: (system descriptorFor: GlorpCustomer).
	self assert: '(BANK_TRANS.ID = 7)' equalsIgnoringOuterBrackets: expression sqlString.