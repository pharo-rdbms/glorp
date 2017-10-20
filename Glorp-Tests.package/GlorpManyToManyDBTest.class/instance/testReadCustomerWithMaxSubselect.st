tests-subselect
testReadCustomerWithMaxSubselect

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:each | 
					(each max: [:eachCust | eachCust accounts id]) = 9874].
		self assert: customers size = 1.
		self assert: customers first id = 27.
		customers := session
				read: GlorpCustomer
				where:
					[:each | 
					(each accounts id sqlMax) = 22].
		self assert: customers size = 1.
		self assert: customers first id = 28.].