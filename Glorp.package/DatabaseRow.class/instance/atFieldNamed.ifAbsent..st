accessing
atFieldNamed: aString ifAbsent: aBlock

	| field |
	field := table fieldNamed: aString ifAbsent: aBlock.
	^self at: field ifAbsent: aBlock.