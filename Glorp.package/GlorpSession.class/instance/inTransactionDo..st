api/transactions
inTransactionDo: aBlock
	"Execute aBlock in a database transaction. If one is already in progress, evaluate aBlock and return. If not, start a transaction, evaluate aBlock and commit or rollback the transaction before returning."

	^self accessor inTransactionDo: aBlock