support
writePersonWithEmailAddresses
	| addressRow personRow emailAddress1Row emailAddress2Row |
	addressRow := session system exampleAddressRow.
	session writeRow: addressRow.
	personRow := session system examplePersonRow1.
	personId := personRow atFieldNamed: 'ID'.
	session writeRow: personRow.
	emailAddress1Row := session system exampleEmailAddressRow1.
	emailAddress2Row := session system exampleEmailAddressRow2.
	emailId1 := emailAddress1Row at: (emailAddress1Row table fieldNamed: 'ID').
	emailId2 := emailAddress2Row at: (emailAddress2Row table fieldNamed: 'ID').
	session writeRow: emailAddress1Row.
	session writeRow: emailAddress2Row.