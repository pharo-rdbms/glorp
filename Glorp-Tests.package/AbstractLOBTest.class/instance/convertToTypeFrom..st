private
convertToTypeFrom: anObject
	"For SQL-Server, return the function which converts anObject's value to my type."
	
	^anObject
		ifNotNil:
			[FunctionExpression for: #convertTo: withArguments: (Array with: anObject asGlorpExpression) basedOn: type asGlorpExpression system: session system]