accessing
name: aSymbol
	| symbol |
	symbol := aSymbol isNil ifTrue: [aSymbol] ifFalse: [aSymbol asSymbol].
	name := symbol