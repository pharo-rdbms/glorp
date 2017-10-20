transactions
inTransactionDo: aBlock
	"Execute aBlock in a database transaction. If one is already in progress, just continue. If not, start a transaction."

	| alreadyInTransaction result |
	[ 
	alreadyInTransaction := self isInTransaction.
	alreadyInTransaction ifFalse: [self beginTransaction. ].
	result := aBlock numArgs = 1 ifTrue: [aBlock value: self] ifFalse: [aBlock value].
	alreadyInTransaction ifFalse: [self commitTransaction]]
		ifCurtailed:
			[alreadyInTransaction ifFalse: [self rollbackTransaction]].
	^result.