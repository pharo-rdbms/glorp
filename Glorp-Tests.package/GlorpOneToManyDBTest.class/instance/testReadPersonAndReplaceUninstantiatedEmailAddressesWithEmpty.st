tests-read
testReadPersonAndReplaceUninstantiatedEmailAddressesWithEmpty
	| |
	self
		inTransactionDo:
			[
			self 
				inUnitOfWorkDo: [person emailAddresses: #().]
				initializeWith: [self writePersonWithEmailAddresses].
			emailId1 := nil.
			emailId2 := nil.
			self readPerson.
			self checkEmailAddresses: person emailAddresses.
			self checkNumberOfEmailAddressesInDB: 2].