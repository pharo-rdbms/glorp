conversion-strings
symbolToString: aSymbol for: aType
	aSymbol isNil ifTrue: [^nil].
	^self padString: aSymbol asString for: aType.