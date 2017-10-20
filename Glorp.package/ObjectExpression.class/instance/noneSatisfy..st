internal
noneSatisfy: anExpression 
	| newExpression |
	newExpression := SubSelectExpression 
		named: #noneSatisfy:
		basedOn: self
		withArguments: (Array with: anExpression).
	^newExpression.