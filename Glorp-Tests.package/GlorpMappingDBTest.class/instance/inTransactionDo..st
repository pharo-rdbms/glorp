support
inTransactionDo: aBlock
	[session beginTransaction.
	aBlock value] ensure: [session rollbackTransaction].