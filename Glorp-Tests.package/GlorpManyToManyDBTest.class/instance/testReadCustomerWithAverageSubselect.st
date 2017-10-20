tests-subselect
testReadCustomerWithAverageSubselect

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:each | 
					(each average: [:eachCust | eachCust accounts id]) = ((9874 + 6) / 2)].
		self assert: customers size = 1.
		self assert: customers first id = 27.
		customers := session
				read: GlorpCustomer
				where:
					[:each | 
					(each accounts id sqlAverage) = 22].
		self assert: customers size = 1.
		self assert: customers first id = 28.].