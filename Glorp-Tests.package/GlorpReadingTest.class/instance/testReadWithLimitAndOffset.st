tests
testReadWithLimitAndOffset

	session platform supportsOffset ifFalse: [^self].
	[session beginTransaction.
	session
		inUnitOfWorkDo:
			[(1 to: 5) do: [:i | session register: ((GlorpAddress new)
													id: i;
													yourself)]].
	self assert: (session execute: ((SimpleQuery read: GlorpAddress limit: 2)
									offset: 2;
									yourself)) size = 2.
	self assert: (session execute: ((SimpleQuery read: GlorpAddress limit: 0)
									offset: 2;
									yourself)) size = 0.
	self assert: (session execute: ((SimpleQuery read: GlorpAddress)
									offset: 6;
									yourself)) size = 0] ensure: [session rollbackTransaction].