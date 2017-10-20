api
getFunction: aSymbol withArguments: anArray

	| expression |
	expression := FunctionExpression for: aSymbol withArguments: anArray basedOn: self.
	expression isNil ifTrue: [^nil].
	^expression.