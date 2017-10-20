*Glorp-Core
asGlorpExpressionForDescriptor: aDescriptor

	| base |
	base := BaseExpression new.
	base descriptor: aDescriptor.
	^self asGlorpExpressionOn: base.