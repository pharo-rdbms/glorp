api
parameter: aConstantExpression
	"Create a parameter expression with the given name. But note that the name doesn't have to be a string. Database fields, symbols, and integers are all plausible"
	| value |
	value := aConstantExpression class == ParameterExpression ifTrue: [aConstantExpression field] ifFalse: [aConstantExpression value].
	^ParameterExpression forField: value basedOn: self.