tests-functions
testCountStarInRetrieveWithConstants
	| query result account extraAccount |
	
	[session beginTransaction.
	self writeCustomer1Rows.
	extraAccount := session system exampleAccountRow3.
	session writeRow: extraAccount.


	query := Query read: GlorpBankAccount.
	query session: session.
	query retrieve: [:each | each countStar].
	query retrieve: [:each | 'X'].
	result := query executeIn: session.
	self assert: result size = 1.
	self assert: result first = #(3 'X').
	account := result first] 
			ensure: [session rollbackTransaction]