tests-read
testReadPersonWithAddress
	self inTransactionDo: [
		self writePersonWithAddress.
		self readPerson.
		self checkPerson.
		self checkAddress].