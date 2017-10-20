tests-subselect
testReadCustomerWithCountSubselect

	| customersWithOneAccount customersWithTwoAccounts customersWithLessThanFiveAccounts |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customersWithOneAccount := session
				read: GlorpCustomer
				where:
					[:each | 
					(each getConstant: 1) = (each count: [:eachCust | eachCust accounts])].
			customersWithTwoAccounts := session
				read: GlorpCustomer
				where:
					[:each | 
					(each count: [:eachCust | eachCust accounts]) = 2].
			"fully general syntax. doesn't require any helper methods, just the existence of the function"
			customersWithLessThanFiveAccounts := session
				read: GlorpCustomer
				where: [:each | (each aggregate: each accounts as: #countStar) < 5].
		self assert: customersWithOneAccount size = 1.
		self assert: customersWithOneAccount first id = 28.
		self assert: customersWithTwoAccounts size = 1.
		self assert: customersWithTwoAccounts first id = 27.
		self assert: customersWithLessThanFiveAccounts size = 2].