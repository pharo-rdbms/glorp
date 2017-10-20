internal
specialSymbolToPerformFor: aSymbol
	"Avoid polymorphism between things you can send to an expression inside a query block and things you can do to an expression to iterate over an expression true"
	aSymbol == #anySatisfy: ifTrue: [^#anySatisfyDefault:].
	aSymbol == #select: ifTrue: [^#sqlSelect:].
	^aSymbol.