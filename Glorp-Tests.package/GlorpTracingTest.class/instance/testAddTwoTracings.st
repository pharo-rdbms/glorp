tests
testAddTwoTracings

	tracing addExpression: (tracing base get: #foo).
	tracing addExpression: (tracing base get: #bar).
	self assert: tracing allTracings size = 3.
	self assert: tracing allTracings first == tracing base.