tests-read
testReadPersonAndAddBogusObjectInsteadOfEmailAddresses2
	self inTransactionDo: [
		self should: [self 
				inUnitOfWorkDo: [person emailAddresses: GlorpEmailAddress new]
				initializeWith: [self writeHomelessPerson]]
			raise: GlorpInvalidTypeError].