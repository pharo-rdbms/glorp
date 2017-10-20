tests
testRead

	| worker |
	[session beginTransaction.
	self writeTestData.
	worker := session execute: (Query readOneOf: GlorpWorker where: [:each | each id = 1234]).

	self assert: (self idsFor: worker pendingJobs) = #(1 2).
	self assert: (self idsFor: worker finishedJobs) = #(3 4).
	self assert: (self idsFor: worker priorityJobs) = #(3).

	] ensure: [session rollbackTransaction].