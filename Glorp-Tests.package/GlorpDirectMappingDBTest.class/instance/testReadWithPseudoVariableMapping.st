tests
testReadWithPseudoVariableMapping

	| peopleWithAddresses peopleWithoutAddresses |
	[session beginTransaction.
	self writeAddress.
	self writeHomelessPerson.
	self writeHomefulPerson.
	peopleWithAddresses := session read: GlorpPerson where: [:each | each addressId notNIL].
	peopleWithoutAddresses := session read: GlorpPerson where: [:each | each addressId isNIL].
	self assert: peopleWithAddresses size = 1.
	self assert: peopleWithoutAddresses size = 1.
	self assert: peopleWithAddresses first id = 3.
	self assert: peopleWithoutAddresses first id = 4.]
		ensure: [session rollbackTransaction].