api
get: aSymbol 
	"Return the mapping expression corresponding to the named attribute"

	| reallyASymbol functionExpression |
	reallyASymbol := aSymbol asSymbol.
	functionExpression := self getFunction: aSymbol withArguments: #().
	functionExpression isNil ifFalse: [^functionExpression].
	^self mappingExpressions at: reallyASymbol
		ifAbsentPut: [MappingExpression named: reallyASymbol basedOn: self]