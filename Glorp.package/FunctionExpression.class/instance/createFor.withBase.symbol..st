copying
createFor: anArray withBase: anExpression symbol: aSymbol
	| new |
	new := self copy.
	new base: anExpression.
	new symbol: aSymbol.
	new type: type.
	new arguments: anArray.
	^new.