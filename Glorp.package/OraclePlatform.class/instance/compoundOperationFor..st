database-specific
compoundOperationFor: aSymbol
	"Return the platform specific version of a compound statement symbol"
	aSymbol == #EXCEPT ifTrue: [^'MINUS'].
	^aSymbol.