api
getFunction: aSymbol withArguments: anArray in: system

	| expression |
	expression := FunctionExpression for: aSymbol withArguments: anArray basedOn: self system: system.
	expression isNil ifTrue: [^nil].
	^expression.