tests-read
testReadPersonAndRemoveEmailAddress
	self
		inTransactionDo:
			[
			self 
				inUnitOfWorkDo: [person emailAddresses removeLast]
				initializeWith: [self writePersonWithEmailAddresses].
			emailId2 := nil.
			self readPerson.
			self checkEmailAddresses: person emailAddresses.
			self checkNumberOfEmailAddressesInDB: 2].