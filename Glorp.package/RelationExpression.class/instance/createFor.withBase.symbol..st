copying
createFor: arguments withBase: anExpression symbol: aSymbol
	"Create a copy of our expression with the given parameters. Used in function creation, for 'functions' like isNil that really just turn into relations."

	^self class
		named: relation
		basedOn: anExpression
		withArguments: (Array with: rightChild).