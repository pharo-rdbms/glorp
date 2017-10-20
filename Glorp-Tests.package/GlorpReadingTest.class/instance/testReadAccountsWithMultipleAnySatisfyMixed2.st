tests
testReadAccountsWithMultipleAnySatisfyMixed2
	| query result |
	 
	[| block |
	session beginTransaction.
	self writeCustomer1Rows.
	block := 
			[:account | 
			(account accountHolders anySatisfyExists: [:each | each id = 24]) 
				| (account accountHolders anySatisfyJoin: [:each | each id = 27])].
	query := Query read: GlorpBankAccount where: block.
	result := session execute: query.
	self assert: result size = 2] 
			ensure: [session rollbackTransaction]