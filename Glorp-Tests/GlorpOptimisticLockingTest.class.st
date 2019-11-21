Class {
	#name : #GlorpOptimisticLockingTest,
	#superclass : #GlorpSessionBasedTest,
	#category : 'Glorp-Tests-Database'
}

{ #category : #tests }
GlorpOptimisticLockingTest >> changeABookFrom: books [
	^session
		transact:
			[session register: books.
			books first copiesInStock: books first copiesInStock - 1].
]

{ #category : #support }
GlorpOptimisticLockingTest >> setUp [
	super setUp.
	session system: GlorpLockingDescriptorSystem new.
	session beginTransaction.
	session transact: [session register: session system example1].
]

{ #category : #support }
GlorpOptimisticLockingTest >> tearDown [
	session rollbackTransaction.
	super tearDown.
]

{ #category : #tests }
GlorpOptimisticLockingTest >> testSuccessfulUpdate [
	| books versions newVersions |
	books := session read: GlorpBook orderBy: #id.
	versions := (session accessor executeSQLString: 'SELECT VERSION FROM BOOK ORDER BY ID') collect: [:each | each first].
	session modify: books in: [
		books do: [:each | each copiesInStock: (each copiesInStock * 2)]].
	newVersions := (session accessor executeSQLString: 'SELECT VERSION FROM BOOK ORDER BY ID') collect: [:each | each first].
	self assert: newVersions = (versions collect: [:each | each + 1]).
]

{ #category : #tests }
GlorpOptimisticLockingTest >> testSuccessfulUpdateOntoNullVersionField [
	| books copies someBook |
	someBook := session readOneOf: GlorpBook.
	session accessor executeSQLString: 'UPDATE BOOK SET VERSION = NULL WHERE ID = ', someBook id printString. 
	session reset.
	books := session read: GlorpBook orderBy: #id.
		copies := books collect: [:each | each copiesInStock].
	session transact: [
		session register: books.
		books do: [:each | each copiesInStock: (each copiesInStock - 1)]].
	session reset.
	books := session read: GlorpBook orderBy: #id.
	self assert: (books collect: [:each | each copiesInStock]) = (copies collect: [:each | each - 1]).
]

{ #category : #tests }
GlorpOptimisticLockingTest >> testSuccessfulUpdateTwiceWithRefresh [
	| book |
	book := session readOneOf: GlorpBook where: [:each | each title like: 'Mastering%'].
	session modify: book in: [
		book copiesInStock: 4].
	session refresh: book.
	self assert: book copiesInStock = 4.
	"Make sure we've properly updated the optimistic lock field"
	session modify: book in: [
		book copiesInStock: 7].
	session reset.
	book := session readOneOf: GlorpBook where: [:each | each title like: 'Mastering%'].
	self assert: book copiesInStock = 7.
]

{ #category : #tests }
GlorpOptimisticLockingTest >> testSuccessfulUpdateTwiceWithRefreshAndSaveAndContinue [
	| book |
	session beginUnitOfWork.
	book := session readOneOf: GlorpBook where: [:each | each title like: 'Mastering%'].
	book copiesInStock: 4.
	session saveAndContinue.
	session refresh: book.
	self assert: book copiesInStock = 4.
	"Make sure we've properly updated the optimistic lock field"
	book copiesInStock: 7.
	session commitUnitOfWork.
	session reset.
	book := session readOneOf: GlorpBook where: [:each | each title like: 'Mastering%'].
	self assert: book copiesInStock = 7.
]

{ #category : #tests }
GlorpOptimisticLockingTest >> testUnsuccessfulUpdateProceedingAndFailing [
	| books |
	books := session read: GlorpBook.
	session accessor
		executeSQLStringNoResult: 'UPDATE BOOK SET COPIES_IN_STOCK = 7, VERSION = 3'.
	self should: [[self changeABookFrom: books] on: GlorpWriteFailure do: [:ex | ex resume: false]] raise: GlorpTransactionFailure.
		
	session reset.
	books := session read: GlorpBook.
	self assert: (books collect: [:each | each copiesInStock]) = #( 7 7).
]

{ #category : #tests }
GlorpOptimisticLockingTest >> testUnsuccessfulUpdateProceedingAnyway [
	| books |
	books := session read: GlorpBook.
	session accessor
		executeSQLStringNoResult: 'UPDATE BOOK SET COPIES_IN_STOCK = 7, VERSION = 3'.
	[self changeABookFrom: books] on: GlorpWriteFailure do: [:ex | ex resume: true].
		
	session reset.
	books := session read: GlorpBook.
	self assert: (books collect: [:each | each copiesInStock]) = #( 7 7).
]

{ #category : #tests }
GlorpOptimisticLockingTest >> testUnsuccessfulUpdateWithNoAction [
	"This is a little quirky. SUnit's action in should:raise: is to exit the exception with true. So the thing just short circuits, and we don't get a transaction failure because we killed the whole unit of work. This is, in general, what will happen if we handle and don't resume the write failures."
	| books |
	books := session read: GlorpBook.
	session accessor
		executeSQLStringNoResult: 'UPDATE BOOK SET COPIES_IN_STOCK = 7, VERSION = 3'.
	self shouldnt: [
		self should: [self changeABookFrom: books] raise: GlorpWriteFailure]
		raise: GlorpTransactionFailure.
	session reset.
	books := session read: GlorpBook.
	self assert: (books collect: [:each | each copiesInStock]) = #(7 7).
]
