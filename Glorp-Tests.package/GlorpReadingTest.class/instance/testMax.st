tests-functions
testMax
	| query result account |
	
	[session beginTransaction.
	self writeCustomer1Rows.

	query := Query read: GlorpBankAccount.
	query retrieve: [:each | each accountNumber accountNumber max].
	result := query executeIn: session.
	self assert: result size = 1.
	self assert: result first = '4'.
	account := result first] 
			ensure: [session rollbackTransaction]