tests-subselect
testReadCustomerWithFilteredSubSelectToAccounts3

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | 
					(eachCustomer accounts select: [:eachAccount | eachAccount id > 5 ]) sqlCount <= 1].
			self assert: customers size = 1].