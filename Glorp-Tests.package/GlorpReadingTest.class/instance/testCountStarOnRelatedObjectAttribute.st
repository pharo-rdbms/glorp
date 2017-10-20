tests-functions
testCountStarOnRelatedObjectAttribute
	| query result account extraAccount |
	
	[session beginTransaction.
	self writeCustomer1Rows.
	extraAccount := session system exampleAccountRow3.
	session writeRow: extraAccount.


	query := Query read: GlorpBankAccount.
	query retrieve: [:each | each accountHolders id countStar].
	result := query executeIn: session.
	self assert: result size = 1.
	self assert: result first = 2.
	account := result first] 
			ensure: [session rollbackTransaction]