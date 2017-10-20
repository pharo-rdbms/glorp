api/transactions
inUnitOfWorkDo: aBlock
	"Evaluate aBlock within a UnitOfWork. This method will only commit or rollback a unit of work that it creates. If there is an ongoing unit of work, the sender must commit or rollback. Likewise, if there is an ongoing transaction, the sender must commit or rollback the transaction. See the class comment for more details."

	| result myUnitOfWork |
	[myUnitOfWork := self hasUnitOfWork not.
	myUnitOfWork ifTrue: [self beginUnitOfWork].
	result := aBlock numArgs = 1 ifTrue: [aBlock value: self] ifFalse: [aBlock value].
	myUnitOfWork ifTrue: [self commitUnitOfWork]]
		ifCurtailed:
			[myUnitOfWork ifTrue: [self rollbackUnitOfWork]].
	^result