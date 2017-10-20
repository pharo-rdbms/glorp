running
testObjDeleteInsertLinkInLaterUoV
	"We delete and create a Task in the same Unit of Work forcing use of the same primary key, but only link it to the same Worker in a later Unit of Work."

	| worker oldTask newTask oldTaskKey |
	session inUnitOfWorkDo:
		[worker := session readOneOf: GlorpTaskedWorker where: [:each | each name = 'Jenny'].
		oldTask := worker tasks values first.
		oldTaskKey := worker tasks keys asOrderedCollection first.
		worker removeTaskAtKey: oldTaskKey.
		session delete: oldTask.
		newTask := GlorpWorkerTask new description: 'Wax floors'; id: oldTask id; yourself.
		session register: newTask].

	session inUnitOfWorkDo:
		[worker := session readOneOf: GlorpTaskedWorker where: [:each | each name = 'Jenny'].
		newTask := session readOneOf: GlorpWorkerTask where: [:each | each description = 'Wax floors'].
		worker addTask: newTask key: 'Wax'].

	worker := session readOneOf: GlorpTaskedWorker where: [:each | each name = 'Jenny'].
	self assert: (worker tasks anySatisfy: [:task | task description = 'Wax floors'])