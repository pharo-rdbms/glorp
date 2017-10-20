tests-read
testReadPersonAndAddAddress
	self inTransactionDo: [
		self 
			inUnitOfWorkDo: [person address: (GlorpAddress new id: 5555; street: 'hello'; number: 'world')]
			initializeWith: [self writeHomelessPerson].
		self readPerson.
		self checkPerson].