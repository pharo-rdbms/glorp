support
assertIdentityOf: aBlock and: anotherBlock
	
 	| base |
	base := BaseExpression new.
	self assert: (aBlock asGlorpExpressionOn: base) == (anotherBlock asGlorpExpressionOn: base)