tests-subselect
testReadCustomerWithSimpleSubSelectToAccounts

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | 
					eachCustomer accounts
						anySatisfyExists: [:eachAccount | eachAccount id <> 12]].
			self assert: customers size = 2].