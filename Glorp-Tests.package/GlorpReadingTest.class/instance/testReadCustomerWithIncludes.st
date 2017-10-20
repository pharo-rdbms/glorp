tests
testReadCustomerWithIncludes
	| query result accounts account |
	
	[session beginTransaction.
	self writeCustomer1Rows.
	account := session readOneOf: GlorpBankAccount where: [:each | each accountNumber branchNumber = 2].
	query := Query read: GlorpCustomer
				where: 
					[:person | 
					person accounts includes: account].
	result := session execute: query.
	self assert: result size = 1.
	accounts := result first accounts getValue.
	self assert: (accounts includes: account).
	self assert: accounts size = 2] 
			ensure: [session rollbackTransaction]