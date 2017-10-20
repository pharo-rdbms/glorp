tests
testMappingBase

	| base |
	base := BaseExpression new.
	self assert: (base get: #someAttribute) base == base