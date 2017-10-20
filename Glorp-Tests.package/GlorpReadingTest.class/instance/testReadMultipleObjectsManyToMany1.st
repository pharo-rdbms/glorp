tests
testReadMultipleObjectsManyToMany1
	| query result account |
	
	[session beginTransaction.
	self writeCustomer1Rows.

	query := Query read: GlorpBankAccount.
	query alsoFetch: [:each | each accountHolders].
	result := query executeIn: session.
	self assert: result size = 2.
	account := result first.
	self deny: account accountHolders isGlorpProxy.
	self assert: account accountHolders size = 1.
	self assert: (account accountHolders first == (result last accountHolders first))] 
			ensure: [session rollbackTransaction]