running
depopulate
	| workers tasks |
	session reset.
	session beginUnitOfWork.
	workers := session read: GlorpTaskedWorker.
	session deleteAll: workers.
	tasks := session read: GlorpWorkerTask.
	session deleteAll: tasks.
	session commitUnitOfWork.