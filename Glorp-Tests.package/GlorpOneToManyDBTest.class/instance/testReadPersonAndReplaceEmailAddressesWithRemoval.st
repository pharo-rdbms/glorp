tests-read
testReadPersonAndReplaceEmailAddressesWithRemoval
	| |
	self
		inTransactionDo:
			[self 
				inUnitOfWorkDo: [
					person emailAddresses: (Array with: person emailAddresses first) ]
				initializeWith: [self writePersonWithEmailAddresses].
			emailId2 := nil.
			self readPerson.
			self checkEmailAddresses: person emailAddresses.
			self checkNumberOfEmailAddressesInDB: 2].