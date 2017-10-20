support
writeAddress
	| addressRow |
	addressRow := session system exampleAddressRow.
	session writeRow: addressRow.