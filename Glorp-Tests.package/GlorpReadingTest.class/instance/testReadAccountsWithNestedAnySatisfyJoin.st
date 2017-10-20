tests
testReadAccountsWithNestedAnySatisfyJoin
	| query result |
	[| block |
	session beginTransaction.
	self writeCustomer1RowsWithTransactions.
	block := 
			[:account | 
			account accountHolders anySatisfyJoin: [:each | each transactions anySatisfyJoin: [:eachTrans |
			eachTrans id ~= nil]]].
	query := Query read: GlorpBankAccount where: block.
	result := session execute: query.
	self assert: result size = 2] 
			ensure: [session rollbackTransaction]