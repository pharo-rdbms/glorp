tests
testAddDuplicateTracings

	| all |
	tracing addExpression: (tracing base get: #foo).
	tracing addExpression: (tracing base get: #foo).
	all := tracing allTracings.
	self assert: all size = 2.
	self assert: all first == tracing base.