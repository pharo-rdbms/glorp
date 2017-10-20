type converters
converterNamed: aSymbol

	^self converters at: aSymbol ifAbsentPut: [
		| converter |
		converter := self perform: (aSymbol, 'Converter') asSymbol.
		converter name: aSymbol]