tests
testReadWithLimit
	| results |
	session platform supportsLimit ifFalse: [^self].
	results := Set new.
	[session beginTransaction.
	session
		inUnitOfWorkDo:
			[(1 to: 5) do: [:i | session register: ((GlorpAddress new)
													id: i;
													yourself)]].
	results
		add: (session execute: (SimpleQuery read: GlorpAddress limit: 3)) size;
		add: (session execute: (SimpleQuery read: GlorpAddress where: true limit: 3)) size;
		add: (session execute: (SimpleQuery read: GlorpAddress limit: 3)) size;
		add: (session execute: (SimpleQuery read: GlorpAddress where: true limit: 3)) size;
		add: (session read: GlorpAddress limit: 3) size;
		add: (session read: GlorpAddress where: true limit: 3) size.
	self assert: (results allSatisfy: [:ea | ea = 3])] ensure: [session rollbackTransaction].