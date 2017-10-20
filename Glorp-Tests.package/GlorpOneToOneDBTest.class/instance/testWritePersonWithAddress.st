tests-write
testWritePersonWithAddress
	|newPerson |
	self inTransactionDo: [
		session beginUnitOfWork.
		newPerson := GlorpPerson example1.
		personId := newPerson id.
		session register: newPerson.
		session commitUnitOfWork.
		session reset.
		self readPerson.
		self assert: person id = newPerson id.
		self assert: person name = newPerson name.
		self assert: person address id = newPerson address id.
		self assert: person address street = newPerson address street].