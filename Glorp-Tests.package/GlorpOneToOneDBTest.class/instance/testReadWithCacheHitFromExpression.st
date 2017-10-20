tests-read
testReadWithCacheHitFromExpression
	self
		inTransactionDo:
			[self
				inUnitOfWorkDo:
					[self assert: person address yourSelf id = 123.
					session accessor permitNothing.
					session readOneOf: GlorpAddress where: [:each | each id = 123]]].