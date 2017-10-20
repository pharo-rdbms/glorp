tests
testReadWithOffset
	session platform supportsOffset ifFalse: [^self].
	[session beginTransaction.
	session
		inUnitOfWorkDo:
			[(1 to: 5) do: [:i | session register: ((GlorpAddress new)
													id: i;
													yourself)]].
	self assert: (session execute: ((SimpleQuery read: GlorpAddress)
									offset: 2;
									yourself)) size = 3] ensure: [session rollbackTransaction].