api
get: aSymbol withArguments: anArray 

	| specialExpression functionExpression |
	functionExpression := self getFunction: aSymbol withArguments: anArray.
	functionExpression isNil ifFalse: [^functionExpression].
	specialExpression := self performSpecialExpression: aSymbol withArguments: anArray.
	specialExpression isNil ifFalse: [^specialExpression].
	anArray isEmpty ifTrue: [^self get: aSymbol].
	^RelationExpression
		named: aSymbol
		basedOn: self
		withArguments: anArray