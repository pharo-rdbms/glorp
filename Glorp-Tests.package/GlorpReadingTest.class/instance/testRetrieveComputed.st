tests-functions
testRetrieveComputed
	| query  results |
	
	[session beginTransaction.
	self writeCustomer1Rows.

	query := Query read: GlorpBankAccount.
	query retrieve: [:each | each  id].
	query retrieve: [:each | each  id * 2].
	query retrieve: [:each | 2].
	query retrieve: [:each | each  id * each  id].
	results := query executeIn: session.
	results do: [:eachRow  | 
		self assert: (eachRow first * eachRow first) = eachRow last.
		self assert: (eachRow at: 2) = (2* eachRow first).
		self assert: (eachRow at: 3) = 2]]
			ensure: [session rollbackTransaction]