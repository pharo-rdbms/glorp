tests
testReadAccountsWithCompoundAnySatisfyJoin
	| query result |
	
	[| block |
	session beginTransaction.
	self writeCustomer1Rows.
	block := 
			[:account | 
			account accountHolders anySatisfyJoin: [:each | (each id = 27) & (each name = 'aCustomer')]].
	query := Query read: GlorpBankAccount where: block.
	result := session execute: query.
	self assert: result size = 2] 
			ensure: [session rollbackTransaction]