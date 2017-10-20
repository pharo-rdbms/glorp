running
testLinkReplace
	"Change link table rows, not either of the two class tables.  This will not throw an exception in RowMap>>collapseMatchingInsertsAndDeletesFor:"

	| tasks worker taskToRemove |
	session inUnitOfWorkDo:
		[worker := session readOneOf: GlorpTaskedWorker where: [:each| each name = 'Jim'].
		tasks := session read: GlorpWorkerTask orderBy: #description.
		taskToRemove := worker tasks keys asOrderedCollection first.
		worker addTask: (tasks at: 2) key: 'Shop'.
		worker addTask: (tasks at: 4) key: 'Relax'.
		worker removeTaskAtKey: taskToRemove].

	worker := session readOneOf: GlorpTaskedWorker where: [:each| each name = 'Jim'].
	tasks := worker tasks.
	self assert: (tasks size = 2).
	self assert: (tasks keys includes: 'Shop').
	self assert: (tasks keys includes: 'Relax').