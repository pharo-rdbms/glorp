api
get: aSymbol withArguments: anArray

	| functionExpression |
	functionExpression := self getFunction: aSymbol withArguments: anArray.
	functionExpression isNil ifFalse: [^functionExpression].
	anArray isEmpty ifTrue: [self error: 'Field expressions do not have attributes'].
	^RelationExpression named: aSymbol basedOn: self withArguments: anArray.