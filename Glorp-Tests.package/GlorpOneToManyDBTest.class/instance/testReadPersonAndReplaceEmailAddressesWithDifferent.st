tests-read
testReadPersonAndReplaceEmailAddressesWithDifferent
	| |
	self
		inTransactionDo:
			[self 
				inUnitOfWorkDo: [
					person emailAddresses: (Array with: (GlorpEmailAddress new id: 99876; user: 'postmaster'; host: 'foo.com')) ]
				initializeWith: [self writePersonWithEmailAddresses].
			emailId1 := 99876.
			emailId2 := nil.
			self readPerson.
			self checkEmailAddresses: person emailAddresses.
			self checkNumberOfEmailAddressesInDB: 3].