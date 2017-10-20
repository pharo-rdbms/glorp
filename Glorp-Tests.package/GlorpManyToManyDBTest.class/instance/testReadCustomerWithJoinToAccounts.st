tests-join
testReadCustomerWithJoinToAccounts

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | 
					eachCustomer accounts
						anySatisfyJoin: [:eachAccount | eachAccount accountNumber bankCode = '2']].
			self assert: customers size = 2].