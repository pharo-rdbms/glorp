api
addSource: aField target: anotherField 
	| value targetValue |
	value := (self isConstant: aField) 
				ifTrue: [ConstantExpression for: aField]
				ifFalse: [aField].
	sources add: value.
	targetValue := anotherField class == SimpleQuery
		ifTrue: [anotherField asGlorpExpressionOn: base] 
		ifFalse: [anotherField].
	(self isConstant: targetValue) ifTrue: [
		self error: 'You are attempting to set a constant value as the target of a relationship. I suspect you want to set it on the source instead. Either that or you''re trying to use a field name where a field object is required.'].
	targets add: targetValue