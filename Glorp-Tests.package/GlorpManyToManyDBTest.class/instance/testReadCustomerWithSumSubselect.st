tests-subselect
testReadCustomerWithSumSubselect

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:each | 
					(each sum: [:eachCust | eachCust accounts accountNumber branchNumber]) < 6].
		self assert: customers size = 1.
		self assert: customers first id = 27.
		customers := session
				read: GlorpCustomer
				where:
					[:each | 
					(each accounts accountNumber branchNumber sqlSum) > 6].
		self assert: customers size = 1.
		self assert: customers first id = 28.].