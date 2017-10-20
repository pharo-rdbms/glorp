support
writeTestRows
	| addressRow personRow |
	addressRow := session system exampleAddressRow.
	session writeRow: addressRow.
	personRow := session system examplePersonRow1.
	session writeRow: personRow.