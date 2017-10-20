tests-read
testReadPersonAndAddEmailAddress
	| |
	self
		inTransactionDo:
			[
			self 
				inUnitOfWorkDo: [person emailAddresses add: (GlorpEmailAddress new id: 99876; user: 'postmaster'; host: 'foo.com')]
				initializeWith: [self writePersonWithEmailAddresses].
			emailId3 := 99876.
			self readPerson.
			self checkEmailAddresses: person emailAddresses].