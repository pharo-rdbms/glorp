tests
testAddRecursiveTracings

	| all |
	tracing addExpression: (tracing base get: #foo).
	tracing addExpression: ((tracing base get: #foo) get: #bar).
	all := tracing allTracings.
	self assert: all size = 3.
	self assert: all first == tracing base.
	self assert: all last base == (all at: 2).