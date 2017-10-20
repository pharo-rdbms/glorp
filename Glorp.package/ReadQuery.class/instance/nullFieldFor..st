converting
nullFieldFor: eachField
	self platform requiresCastsForNullsInUnions ifFalse: [^(ConstantExpression for: nil) alias: eachField table name, 'nullField', eachField position printString].
	^FunctionExpression
		for: #cast:
		withArguments: (Array with: (ConstantExpression for: eachField type))
		basedOn: (ConstantExpression for: nil)