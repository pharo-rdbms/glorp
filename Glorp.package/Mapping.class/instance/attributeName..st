accessing
attributeName: aSymbol
	| oldAttribute symbolName |
	symbolName := aSymbol asSymbol.
	oldAttribute := attribute.
	attribute := self classModel attributeNamed: symbolName.
	oldAttribute isNil
		ifTrue: [self initializeAttribute]
		ifFalse: [attribute copyFrom: oldAttribute]