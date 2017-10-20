tests-read
testReadPersonWithoutAddress
	self inTransactionDo: [
		self writeHomelessPerson.
		self writeAddress.
		self readPerson.
		self checkPerson.
		self checkNoAddress].