tests
testDirectQueryWithAbstractClass
	| fromdb |
	session beginTransaction.
	[session inUnitOfWorkDo: [	session register: (GlorpBasicTax new name: 'Tax'; yourself).
								session register: (GlorpSurcharge new name: 'Surcharge'; yourself)].
	session reset.
	fromdb := session read: GlorpTax.
	self assert: fromdb size = 2.
	self assert: (fromdb select: [:emp | emp isMemberOf: GlorpTax]) isEmpty.
	self assert: (fromdb select: [:emp | emp isMemberOf: GlorpBasicTax]) size = 1.
	self assert: (fromdb select: [:emp | emp isMemberOf: GlorpSurcharge]) size = 1] 
			ensure: [session rollbackTransaction]