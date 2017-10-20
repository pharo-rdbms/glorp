tests-subselect
testReadCustomerWithMinSubselect

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:each | 
					(each min: [:eachCust | eachCust accounts id]) = 6].
		self assert: customers size = 1.
		self assert: customers first id = 27.
		customers := session
				read: GlorpCustomer
				where:
					[:each | 
					(each accounts id sqlMin) = 22].
		self assert: customers size = 1.
		self assert: customers first id = 28.].