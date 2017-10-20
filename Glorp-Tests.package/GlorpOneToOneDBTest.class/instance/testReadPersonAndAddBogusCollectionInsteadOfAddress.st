tests-read
testReadPersonAndAddBogusCollectionInsteadOfAddress
	self inTransactionDo: [
		self should: [self 
				inUnitOfWorkDo: [person address: #()]
				initializeWith: [self writeHomelessPerson]]
			raise: GlorpInvalidTypeError].