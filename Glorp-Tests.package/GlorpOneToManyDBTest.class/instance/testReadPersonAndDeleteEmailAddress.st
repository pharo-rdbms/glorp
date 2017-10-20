tests-read
testReadPersonAndDeleteEmailAddress
	self
		inTransactionDo:
			[
			self 
				inUnitOfWorkDo: [
					session delete: person emailAddresses last. 
					person emailAddresses removeLast. ]
				initializeWith: [self writePersonWithEmailAddresses].
			emailId2 := nil.
			self readPerson.
			self checkEmailAddresses: person emailAddresses.
			self checkNumberOfEmailAddressesInDB: 1].