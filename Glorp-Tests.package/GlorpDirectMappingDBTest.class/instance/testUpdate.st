tests
testUpdate
	|newPerson |
	self inTransactionDo: [
		session beginUnitOfWork.
		newPerson := GlorpPerson example1.
		personId := newPerson id.
		session register: newPerson.
		session commitUnitOfWork.
		session reset.
		self readPerson.
		session inUnitOfWorkDo: [
			session register: person.
			person name: 'something else'].
		session reset.
		self readPerson.
		self assert: person id = newPerson id.
		self assert: person name = 'something else'].