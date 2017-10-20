fields
fieldNamed: aString ifAbsent: aBlock

	^self fieldNamed: aString ifAbsent: aBlock caseSensitive: false.