helpers
inTransactionDo: aBlock
	"Like the one in session, but always rollback."
	| alreadyInTransaction result |
	[ 
	alreadyInTransaction := session isInTransaction.
	alreadyInTransaction ifFalse: [session beginTransaction].
	result := aBlock numArgs = 1 ifTrue: [aBlock value: self] ifFalse: [aBlock value].
	alreadyInTransaction ifFalse: [session rollbackTransaction]]
		ifCurtailed:
			[alreadyInTransaction ifFalse: [session rollbackTransaction]].
	^result.