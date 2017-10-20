support
denyIdentityOf: aBlock and: anotherBlock
 
	| base |
	base := BaseExpression new.
	self deny: (aBlock asGlorpExpressionOn: base) == (anotherBlock asGlorpExpressionOn: base)