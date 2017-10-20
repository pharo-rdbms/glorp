tests-subselect
testReadCustomerWithSubSelectToAccounts2

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | 
					eachCustomer accounts
						anySatisfyExists: [:eachAccount | eachAccount accountNumber branchNumber = 3]].
			self assert: customers size = 1].