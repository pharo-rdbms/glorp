tests-join
testReadCustomerWithSimpleJoinToAccounts

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | 
					eachCustomer accounts
						anySatisfyJoin: [:eachAccount | eachAccount id <> 12]].
			self assert: customers size = 2].