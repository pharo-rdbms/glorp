tests-read
testReadPersonAndAddBogusObjectInsteadOfAddress
	self inTransactionDo: [
		self should: [self 
				inUnitOfWorkDo: [person address: GlorpPerson new]
				initializeWith: [self writeHomelessPerson]]
			raise: GlorpInvalidTypeError].