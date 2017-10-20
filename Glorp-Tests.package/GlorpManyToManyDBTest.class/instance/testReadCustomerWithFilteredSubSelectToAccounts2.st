tests-subselect
testReadCustomerWithFilteredSubSelectToAccounts2

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | 
					(eachCustomer accounts select: [:eachAccount | eachAccount accountNumber bankCode = '2']) sqlCount > 1].
			self assert: customers size = 0].