converting
asDistinctFieldOn: anExpression
	self isDistinct ifTrue: [^self asGlorpExpressionOn: anExpression].
	^super asDistinctFieldOn: anExpression.