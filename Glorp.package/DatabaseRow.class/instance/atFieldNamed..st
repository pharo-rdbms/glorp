accessing
atFieldNamed: aString

	| field |
	field := table fieldNamed: aString.
	^self at: field