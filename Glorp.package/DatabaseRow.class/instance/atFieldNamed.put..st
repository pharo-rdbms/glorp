accessing
atFieldNamed: aString put: anObject

	| field |
	field := table fieldNamed: aString.
	^self at: field put: anObject