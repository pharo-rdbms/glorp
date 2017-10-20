instance creation
for: aSymbol withArguments: anArray basedOn: anExpression system: system
	| functionTemplate newFunction |
	functionTemplate := (system isNil
		ifTrue: [self basicFunctions]
		ifFalse: [system platform functions]) at: aSymbol ifAbsent: [^nil].
	newFunction := functionTemplate
		createFor: anArray
		withBase: anExpression
		symbol: aSymbol.
	^newFunction