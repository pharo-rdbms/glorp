accessing
field: aDatabaseFieldOrExpression
	field := (Dialect isBlock: aDatabaseFieldOrExpression)
		ifTrue: [
			self beReadOnly.
			aDatabaseFieldOrExpression asGlorpExpressionOn: (BaseExpression new descriptor: descriptor)]
		ifFalse: [aDatabaseFieldOrExpression]