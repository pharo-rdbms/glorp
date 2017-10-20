tests
testGetFieldFromSecondaryTable
	| expression |
	expression := [:pass | pass getField: 'POINTS']
		asGlorpExpressionForDescriptor: (system descriptorFor: GlorpPassenger).
	self assert: expression sqlString = 'FREQUENT_FLYER.POINTS'.
	self assert: expression class = FieldExpression.
	self assert: expression field table = (system tableNamed: 'FREQUENT_FLYER').