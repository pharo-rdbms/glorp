api/transactions
transact: aBlock
	"Evaluate aBlock inside a transaction and inside a unit of work. This could be called inUnitOfWorkInsideTransactionDo: (but that's too verbose) because we start both a transaction and/or a unit of work if we are not in either or both already.  We commit or rollback only what we started. Otherwise, the sender controls commit/rollback. (Comparing this method with #inUnitOfWorkDo:, in the latter, if there is not already an ongoing transaction a transaction will not get started until the UnitOfWork commits.)"

	| alreadyInTransaction alreadyInUnitOfWork result |
	[[alreadyInUnitOfWork := false.
	alreadyInTransaction := self isInTransaction.
	alreadyInTransaction ifFalse: [self beginTransaction].
	alreadyInUnitOfWork := self hasUnitOfWork.
	alreadyInUnitOfWork ifFalse: [self beginUnitOfWork].
	result := aBlock numArgs = 1 ifTrue: [aBlock value: self] ifFalse: [aBlock value].
	self register: result.
	alreadyInUnitOfWork ifFalse: [self commitUnitOfWork].
	alreadyInTransaction ifFalse: [self commitTransaction]]
		ifCurtailed: [alreadyInUnitOfWork ifFalse: [self rollbackUnitOfWork]]]
			ifCurtailed: [alreadyInTransaction ifFalse: [self rollbackTransaction]].
	^result