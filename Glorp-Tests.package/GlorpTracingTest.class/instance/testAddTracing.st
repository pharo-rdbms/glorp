tests
testAddTracing

	| all |
	tracing addExpression: (tracing base get: #foo).
	all := tracing allTracings.
	self assert: all size = 2.
	self assert: all first == tracing base.
	self assert: all last == (tracing base get: #foo).