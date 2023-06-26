"
Users can delete an object from their database and then create another object with the same primary key all in the same unit of work.  Glorp does the same thing for link tables.  In both cases, Glorp attempts to replace the matching delete and insert statements with an update statement.  However Glorp expects to set the keys itself in link tables and will complain if they are already there.  Test that user-forced delete and insert with the same primary keys works for objects, but that invalid link table delete and insert will be caught.

"
Class {
	#name : #GlorpMatchDeleteInsertTest,
	#superclass : #GlorpSessionBasedTest,
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #'private - running' }
GlorpMatchDeleteInsertTest >> depopulate [
	| workers tasks |
	session reset.
	session beginUnitOfWork.
	workers := session read: GlorpTaskedWorker.
	session deleteAll: workers.
	tasks := session read: GlorpWorkerTask.
	session deleteAll: tasks.
	session commitUnitOfWork.
]

{ #category : #'private - running' }
GlorpMatchDeleteInsertTest >> populate [
	| workers |
	session beginUnitOfWork.
	workers := GlorpTaskedWorker example1.
	session register: workers.
	session commitUnitOfWork.
]

{ #category : #'private - running' }
GlorpMatchDeleteInsertTest >> repopulate [
	self depopulate.
	self populate.
]

{ #category : #running }
GlorpMatchDeleteInsertTest >> setUp [

	super setUp.
	session system: (GlorpDictionaryDescriptorSystem forPlatform: session platform).
	self repopulate
]

{ #category : #running }
GlorpMatchDeleteInsertTest >> tearDown [
	session rollbackUnitOfWork.
	self depopulate.
	super tearDown
]

{ #category : #tests }
GlorpMatchDeleteInsertTest >> testLinkBasic [
	"Just a smoke test to ensure that the general setup is okay."

	| workers exampleWorkers |
	workers := session read: GlorpTaskedWorker orderBy: #name.
	exampleWorkers := (GlorpTaskedWorker example1) asSortedCollection: [:a :b| a name < b name].
	self assert: (workers size = exampleWorkers size).
	self assert: ((workers at: 3) isSimilarToWorker: (exampleWorkers at: 3)).
]

{ #category : #tests }
GlorpMatchDeleteInsertTest >> testLinkDelete [
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
]

{ #category : #tests }
GlorpMatchDeleteInsertTest >> testLinkReplace [
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
]

{ #category : #tests }
GlorpMatchDeleteInsertTest >> testObjDeleteInsertLinkInLaterUoV [
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
]

{ #category : #tests }
GlorpMatchDeleteInsertTest >> testObjDeleteInsertLinkInSameUoW [
	"We delete and create a Task in the same Unit of Work forcing use of the same primary key, and link it to the same Worker in that same Unit of Work."

	| worker oldTask newTask oldTaskKey |
	session inUnitOfWorkDo:
		[worker := session readOneOf: GlorpTaskedWorker where: [:each | each name = 'Jenny'].
		oldTask := worker tasks values first.
		oldTaskKey := worker tasks keys asOrderedCollection first.
		worker removeTaskAtKey: oldTaskKey.
		session delete: oldTask.
		newTask := GlorpWorkerTask new description: 'Wax floors'; id: oldTask id; yourself.
		session register: newTask.
		worker addTask: newTask key: 'Wax'].

	worker := session readOneOf: GlorpTaskedWorker where: [:each | each name = 'Jenny'].
	self assert: (worker tasks anySatisfy: [:task | task description = 'Wax floors'])
]
