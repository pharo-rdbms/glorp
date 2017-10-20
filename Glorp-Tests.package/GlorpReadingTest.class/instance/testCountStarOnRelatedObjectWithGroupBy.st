tests-functions
testCountStarOnRelatedObjectWithGroupBy
	| query result extraAccount |
	
	[session beginTransaction.
	self writeCustomer1Rows.
	extraAccount := session system exampleAccountRow3.
	session writeRow: extraAccount.

	query := Query read: GlorpBankAccount.
	query retrieve: [:each | each accountHolders countStar].
	query groupBy: [:each | each id].
	result := query executeIn: session.
	self assert: result = #(1 1 )] 
			ensure: [session rollbackTransaction]