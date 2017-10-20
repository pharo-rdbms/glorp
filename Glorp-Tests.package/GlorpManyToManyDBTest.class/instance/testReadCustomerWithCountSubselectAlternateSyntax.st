tests-subselect
testReadCustomerWithCountSubselectAlternateSyntax

	| customersWithOneAccount customersWithTwoAccounts |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customersWithOneAccount := session
				read: GlorpCustomer
				where:
					[:each | 
					(each getConstant: 1) = (each accounts sqlCount)].
			customersWithTwoAccounts := session
				read: GlorpCustomer
				where:
					[:each | 
					each accounts sqlCount = 2].
		self assert: customersWithOneAccount size = 1.
		self assert: customersWithOneAccount first id = 28.
		self assert: customersWithTwoAccounts size = 1.
		self assert: customersWithTwoAccounts first id = 27].