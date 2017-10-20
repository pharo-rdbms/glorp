tests
testParameterCount

	self assert: expression numberOfParameters = 1.
	self assert: compoundExpression numberOfParameters = 2.