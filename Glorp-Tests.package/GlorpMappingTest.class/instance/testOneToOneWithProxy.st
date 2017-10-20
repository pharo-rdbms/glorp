tests
testOneToOneWithProxy

	| person  personTable addressTable proxy stub |
	person := GlorpPerson example1.
	proxy := Proxy new.
	proxy session: GlorpSession new.
	stub := GlorpQueryStub readOneOf: GlorpAddress where: [:address | address id = 1].
	stub result: person address.
	proxy query: stub.
	person address: proxy.
	self deny: person address isInstantiated.

	self write: person.

	personTable := system existingTableNamed: 'PERSON'.
	addressTable := system existingTableNamed: 'GR_ADDRESS'.

	self assert: (rowMap includesRowForTable: personTable withKey: person).
	self deny: (rowMap includesRowForTable: addressTable withKey: person address).

	self deny: ((self rowFor: person) hasValueFor: (personTable fieldNamed: 'ADDRESS_ID')).
	self assert: rowMap numberOfEntries = 1.