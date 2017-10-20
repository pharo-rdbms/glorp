converting
asGlorpExpressionForDescriptor: aDescriptor
	"This should only get sent to us if we're the top level of an expression. And since we don't have children, we're also the bottom level. This is only useful for the case where the expression is [:each | true] or [:each | false]."

	^(EmptyExpression on: value)
		rebuildOn: (BaseExpression new descriptor: aDescriptor).