tests-write
testWritePersonWithNoEmailAddresses2

	| newPerson |
	self inTransactionDo: [
		session beginUnitOfWork.
		newPerson := GlorpPerson new.
		newPerson id: 231.
		personId := 231.
		newPerson emailAddresses: OrderedCollection new.
		session register: newPerson.
		session commitUnitOfWork.
		session reset.
		self readPerson.
		self assert: person emailAddresses isEmpty.
		self checkNumberOfEmailAddressesInDB: 0].