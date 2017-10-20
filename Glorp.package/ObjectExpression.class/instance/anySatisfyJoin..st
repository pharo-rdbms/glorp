internal
anySatisfyJoin: anExpression 
	| newExpression |
	anExpression isConstantExpression ifTrue: [self error: 'The argument to anySatisfy: must be a block evaluating to a boolean condition.'].
	self base requiresDistinct: true.
	newExpression := CollectionExpression 
		named: #anySatisfy:
		basedOn: self
		withArguments: (Array with: anExpression).
	self base removeMappingExpression: self.
	^newExpression.