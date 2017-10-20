tests-read
testReadWithCacheHitFromJoin
	self inTransactionDo: [
		self 
			inUnitOfWorkDo: [
				session readOneOf: GlorpAddress.
				session accessor permitNothing.
				self assert: (person address yourSelf id = 123)]].