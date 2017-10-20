support
writePersonWithEmailAddresses
	| personRow emailAddress1Row emailAddress2Row |
	personRow := session system examplePersonRow1.
	personId := personRow atFieldNamed: 'ID'.
	session writeRow: personRow.
	emailAddress1Row := session system exampleEmailAddressRow1.
	emailAddress2Row := session system exampleEmailAddressRow2.
	emailAddress1Row at: (emailAddress1Row table fieldNamed: 'ID').
	emailAddress2Row at: (emailAddress2Row table fieldNamed: 'ID').
	session writeRow: emailAddress1Row.
	session writeRow: emailAddress2Row.