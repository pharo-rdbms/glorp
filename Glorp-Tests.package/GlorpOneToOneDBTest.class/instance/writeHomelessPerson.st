support
writeHomelessPerson
	| personRow |
	personRow := session system examplePersonRow2.
	session writeRow: personRow.
	personId := personRow atFieldNamed: 'ID'.