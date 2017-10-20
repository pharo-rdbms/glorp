tests
testAnySatisfyPrintExists
	| expression |
	system useJoinsForAnySatisfy: false.
	expression := [:cust | cust transactions anySatisfy: [:each | each id = 7]] 
				asGlorpExpressionForDescriptor: (system descriptorFor: GlorpCustomer).
	self assert: (' EXISTS (SELECT s1t1.ID<n> FROM BANK_TRANS s1t1<n> WHERE *s1t1.ID = ?* AND *s1t2.ID = s1t1.OWNER_ID)*' expandMacros withUnixLineEndings match: expression sqlString withUnixLineEndings).