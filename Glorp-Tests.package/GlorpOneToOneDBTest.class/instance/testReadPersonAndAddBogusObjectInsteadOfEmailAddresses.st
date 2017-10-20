tests-read
testReadPersonAndAddBogusObjectInsteadOfEmailAddresses
	self inTransactionDo: [
		self should: [self 
				inUnitOfWorkDo: [person emailAddresses: 42]
				initializeWith: [self writeHomelessPerson]]
			raise: GlorpInvalidTypeError].