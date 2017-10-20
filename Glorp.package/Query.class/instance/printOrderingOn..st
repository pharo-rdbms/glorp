sql generation
printOrderingOn: aStream
	"Before printing, send each expression >>rewriteFunctionArguments.
	It has no effect for most expressions and most functions, but is
	needed with some platforms (see Substring)."

	ordering isNil ifTrue: [^self].
	aStream nextPutAll: ' ORDER BY '.
	GlorpHelper
		do: [:each |
			each
				rewriteFunctionArguments;
				printSQLOn: aStream withParameters: nil]
		for: ordering
		separatedBy: [aStream nextPutAll: ', ']