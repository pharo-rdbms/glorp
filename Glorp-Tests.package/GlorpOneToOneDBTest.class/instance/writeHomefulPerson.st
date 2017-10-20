support
writeHomefulPerson
	| personRow |
	personRow := session system examplePersonRow1.
	session writeRow: personRow.
	personId := personRow atFieldNamed: 'ID'.