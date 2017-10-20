tests
testOneToOne
	
	| person  personTable addressTable |
	person := GlorpPerson example1.
	self write: person.
	self write: person address.
	personTable := system existingTableNamed: 'PERSON'.
	addressTable := system existingTableNamed: 'GR_ADDRESS'.

	self assert: (rowMap includesRowForTable: personTable withKey: person).
	self assert: (rowMap includesRowForTable: addressTable withKey: person address).

	self assert: ((self rowFor: person address) at: (addressTable fieldNamed: 'ID')) = person address id.
	self assert: ((self rowFor: person) at: (personTable fieldNamed: 'ADDRESS_ID')) = person address id.
	self assert: rowMap numberOfEntries = 2.