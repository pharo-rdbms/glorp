tests
writeTransactionRow: anInteger
	| tempRow |
	tempRow := DatabaseRow newForTable: table.
	session platform usesIdentityColumns ifFalse: [
		tempRow atFieldNamed: 'ID' put: anInteger].
	tempRow atFieldNamed: 'AMT_CURR' put: 'CDN'.
	session writeRow: tempRow.