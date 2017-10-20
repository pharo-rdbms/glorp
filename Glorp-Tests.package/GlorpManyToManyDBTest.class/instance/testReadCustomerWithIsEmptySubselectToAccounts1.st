tests-subselect
testReadCustomerWithIsEmptySubselectToAccounts1

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | eachCustomer accounts isEmpty].
			self assert: customers size = 0].