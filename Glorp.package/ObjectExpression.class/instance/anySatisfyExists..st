internal
anySatisfyExists: anExpression 
	| newExpression |
	anExpression isConstantExpression ifTrue: [self error: 'The argument to anySatisfy: must be a block evaluating to a boolean condition.'].
	newExpression := SubSelectExpression 
		named: #anySatisfy:
		basedOn: self
		withArguments: (Array with: anExpression).
	^newExpression.