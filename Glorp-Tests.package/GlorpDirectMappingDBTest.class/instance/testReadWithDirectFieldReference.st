tests
testReadWithDirectFieldReference

	| peopleWithAddresses peopleWithoutAddresses addressIdField |
	[session beginTransaction.
	self writeAddress.
	self writeHomelessPerson.
	self writeHomefulPerson.
	addressIdField := (session system tableNamed: 'PERSON') fieldNamed: 'ADDRESS_ID'.
	peopleWithAddresses := session read: GlorpPerson where: [:each | (each getField: addressIdField) notNIL].
	peopleWithoutAddresses := session read: GlorpPerson where: [:each | (each getField: addressIdField) isNIL].
	self assert: peopleWithAddresses size = 1.
	self assert: peopleWithoutAddresses size = 1.
	self assert: peopleWithAddresses first id = 3.
	self assert: peopleWithoutAddresses first id = 4.
	 ]
		ensure: [session rollbackTransaction].