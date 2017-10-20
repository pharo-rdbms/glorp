api/transactions
commitUnitOfWork
	"Send updates to the database, in an already-existing Transaction if present, otherwise in a newly-created one. A newly-created Transaction is committed.  An existing Transaction is left for the surrounding code (i.e. that created it) to commit or rollback."

	[self isInTransaction
		ifTrue: [currentUnitOfWork commit]
		ifFalse: [self inTransactionDo: [currentUnitOfWork commit]]] 
	ifCurtailed: [self rollbackUnitOfWork].
	currentUnitOfWork := nil.