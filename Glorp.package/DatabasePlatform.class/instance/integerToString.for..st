conversion-strings
integerToString: anInteger for: aType
	anInteger isNil ifTrue: [^nil].
	^self padString: anInteger printString for: aType.