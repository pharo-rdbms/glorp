tests
testExpressionCreation
	| exp |
	exp := collector foo asGlorpExpression.
	self assert: exp name == #foo.
	self assert: exp base class == BaseExpression