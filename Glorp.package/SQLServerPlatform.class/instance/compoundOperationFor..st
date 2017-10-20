database-specific
compoundOperationFor: aSymbol
	"Return the platform specific version of a compound statement symbol"
	aSymbol == #INTERSECT ifTrue: [^'WHERE EXISTS'].
	aSymbol == #MINUS ifTrue: [^'WHERE NOT EXISTS'].
	^aSymbol.