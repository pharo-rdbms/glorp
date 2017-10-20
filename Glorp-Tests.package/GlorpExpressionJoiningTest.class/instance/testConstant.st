tests
testConstant
	| exp |
	exp := ConstantExpression for: 42.
	self assert: (self join: exp) == exp