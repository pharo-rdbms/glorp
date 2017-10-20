tests-read
testReadPersonAndRemoveAddress
	self inTransactionDo: [
		self inUnitOfWorkDo: [
			session delete: person address.
			person address: nil.].
		self readPerson.
		self checkPerson.
		self checkNoAddress.
		self checkNoAddressesInDB].