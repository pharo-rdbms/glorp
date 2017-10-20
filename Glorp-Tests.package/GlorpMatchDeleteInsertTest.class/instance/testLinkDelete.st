running
testLinkDelete
	"Change link table rows, not either of the two class tables.  This will not throw an exception in RowMap>>collapseMatchingInsertsAndDeletesFor:"

	| worker taskKey |
	session beginTransaction.
	session inUnitOfWorkDo: [
		worker := session readOneOf: GlorpTaskedWorker where: [:each| each name = 'Jim'].
		session read: GlorpWorkerTask orderBy: #description.
		taskKey := worker tasks keys asArray first.
		worker tasks removeKey: taskKey ifAbsent:
			[self assert: false description: 'Task not found']].
	session rollbackTransaction.