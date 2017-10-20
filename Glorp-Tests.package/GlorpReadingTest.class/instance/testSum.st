tests-functions
testSum
	| query result |
	
	[session beginTransaction.
	self writeCustomer1Rows.

	query := Query read: GlorpBankAccount.
	query retrieve: [:each | each accountNumber branchNumber sum].
	result := query executeIn: session.
	self assert: result size = 1.
	self assert: result first = 5] 
			ensure: [session rollbackTransaction]