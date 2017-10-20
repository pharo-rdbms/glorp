tests-subselect
testReadCustomerWithFilteredSubSelectToAccounts1

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | 
					(eachCustomer accounts select: [:eachAccount | eachAccount accountNumber bankCode = '2']) sqlCount > 0].
			self assert: customers size = 2].