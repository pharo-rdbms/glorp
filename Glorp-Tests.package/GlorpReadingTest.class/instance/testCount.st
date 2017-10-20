tests-functions
testCount
	| query result account extraAccount |
	
	[session beginTransaction.
	self writeCustomer1Rows.
	extraAccount := session system exampleAccountRow3.
	session writeRow: extraAccount.


	query := Query read: GlorpBankAccount.
	query retrieve: [:each | each id count].
	result := query executeIn: session.
	self assert: result size = 1.
	self assert: result first = 3.
	account := result first] 
			ensure: [session rollbackTransaction]