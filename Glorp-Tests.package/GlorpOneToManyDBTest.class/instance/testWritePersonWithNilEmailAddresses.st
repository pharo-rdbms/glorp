tests-write
testWritePersonWithNilEmailAddresses

	| newPerson |
	self inTransactionDo: [
		session beginUnitOfWork.
		newPerson := GlorpPerson new.
		newPerson id: 231.
		personId := 231.
		newPerson emailAddresses: nil.
		session register: newPerson.
		session commitUnitOfWork.
		session reset.
		self readPerson.
		self assert: person emailAddresses isEmpty.
		self checkNumberOfEmailAddressesInDB: 0].