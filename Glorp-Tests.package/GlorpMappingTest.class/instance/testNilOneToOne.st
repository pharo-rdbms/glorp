tests
testNilOneToOne
	
	| person  personTable addressTable |
	person := GlorpPerson example1.
	person address: nil.
	self write: person.
	self write: person address.
	personTable := system existingTableNamed: 'PERSON'.
	addressTable := system existingTableNamed: 'GR_ADDRESS'.

	self assert: (rowMap includesRowForTable: personTable withKey: person).
	self deny: (rowMap includesRowForTable: addressTable withKey: person address).

	self assert: rowMap numberOfEntries = 1.