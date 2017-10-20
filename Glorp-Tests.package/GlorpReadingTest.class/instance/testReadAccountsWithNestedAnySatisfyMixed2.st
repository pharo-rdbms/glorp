tests
testReadAccountsWithNestedAnySatisfyMixed2
	| query result |
	[| block |
	session beginTransaction.
	self writeCustomer1RowsWithTransactions.
	block := 
			[:account | 
			account accountHolders anySatisfyJoin: [:each | each transactions anySatisfyExists: [:eachTrans |
			eachTrans id ~= nil]]].
	query := Query read: GlorpBankAccount where: block.
	result := session execute: query.
	self assert: result size = 2] 
			ensure: [session rollbackTransaction]