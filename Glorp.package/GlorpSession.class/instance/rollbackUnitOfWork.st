api/transactions
rollbackUnitOfWork

	currentUnitOfWork isNil ifTrue: [^self].
	currentUnitOfWork abort.
	currentUnitOfWork := nil.