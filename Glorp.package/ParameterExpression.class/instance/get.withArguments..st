api
get: aSelector withArguments: anArray
	| functionExpression |
	functionExpression := self getFunction: aSelector withArguments: anArray.
	functionExpression isNil ifFalse: [^functionExpression].
	^RelationExpression
		named: aSelector
		basedOn: self
		withArguments: anArray