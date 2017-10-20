api
get: aSymbol withArguments: anArray
	"We treat NOT as a function, so we have to check for functions here"
	| functionExpression |
	functionExpression := self getFunction: aSymbol withArguments: anArray.
	functionExpression isNil ifFalse: [^functionExpression].
	^anArray size = 1
		ifTrue: [RelationExpression named: aSymbol basedOn: self withArguments: anArray]
		ifFalse: ["This is either an error, or something defined as a selector on relation expressions"
			self perform: aSymbol withArguments: anArray.].