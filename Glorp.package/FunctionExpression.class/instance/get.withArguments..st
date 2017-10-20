api
get: aSymbol withArguments: anArray
	| functionExpression |
	functionExpression := self getFunction: aSymbol withArguments: anArray.
	functionExpression isNil ifFalse: [^functionExpression].
	^RelationExpression
		named: aSymbol
		basedOn: self
		withArguments: anArray