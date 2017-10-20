tests-write
testWritePersonWithoutAddress
	|newPerson |
	self inTransactionDo: [
		session beginUnitOfWork.
		newPerson := GlorpPerson example1.
		newPerson address: nil.
		personId := newPerson id.
		session register: newPerson.
		session commitUnitOfWork.
		session reset.
		self readPerson.
		self assert: person id = newPerson id.
		self assert: person name = newPerson name.
		self assert: person address yourSelf == nil.
		self checkNoAddressesInDB].