support
setUp
	super setUp.
	session := GlorpSessionResource current newSession.
	session beginTransaction.
	addressRow := session system exampleAddressRow.
	session writeRow: addressRow.
	personRow := session system examplePersonRow1.
	session writeRow: personRow.
	emailAddress1Row := session system exampleEmailAddressRow1.
	emailAddress2Row := session system exampleEmailAddressRow2.
	id1 := emailAddress1Row at: (emailAddress1Row table fieldNamed: 'ID').
	id2 := emailAddress2Row at: (emailAddress2Row table fieldNamed: 'ID').
	session writeRow: emailAddress1Row.
	session writeRow: emailAddress2Row.