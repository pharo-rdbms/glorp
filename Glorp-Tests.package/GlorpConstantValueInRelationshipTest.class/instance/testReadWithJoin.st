tests
testReadWithJoin
	| worker |
	[session beginTransaction.
	self writeTestData.
	worker := session
		execute:
			(Query readOneOf: GlorpWorker where: [:each | each pendingJobs id = 1]).
	self assert: worker id = 1234] ensure: [session rollbackTransaction].