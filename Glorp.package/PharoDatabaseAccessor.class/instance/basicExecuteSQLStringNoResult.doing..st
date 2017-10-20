executing
basicExecuteSQLStringNoResult: aString doing: aBlock

	| a |
	a := self basicExecuteSQLString: aString.
	aBlock value.
	^a