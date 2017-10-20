tests
testReadAccountsWithNestedAnySatisfyMixed1
	| query result |
	[| block |
	session beginTransaction.
	self writeCustomer1RowsWithTransactions.
	block := 
			[:account | 
			account accountHolders anySatisfyExists: [:each | each transactions anySatisfyJoin: [:eachTrans |
			eachTrans id ~= nil]]].
	query := Query read: GlorpBankAccount where: block.
	result := session execute: query.
	self assert: result size = 2] 
			ensure: [session rollbackTransaction]