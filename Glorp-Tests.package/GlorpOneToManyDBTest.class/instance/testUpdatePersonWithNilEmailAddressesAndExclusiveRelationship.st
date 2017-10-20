tests-write
testUpdatePersonWithNilEmailAddressesAndExclusiveRelationship

	| newPerson |
	((session system descriptorFor: GlorpPerson) mappingForAttributeNamed: #emailAddresses) beExclusive.
	self inTransactionDo: [
		session beginUnitOfWork.
		newPerson := GlorpPerson new.
		newPerson id: 231.
		personId := 231.
		session register: newPerson.
		session commitUnitOfWork.
		session reset.
		self readPerson.
		session modify: person in: [person emailAddresses: nil].
		session reset.
		self readPerson.
		self assert: person emailAddresses isEmpty.
		self checkNumberOfEmailAddressesInDB: 0].