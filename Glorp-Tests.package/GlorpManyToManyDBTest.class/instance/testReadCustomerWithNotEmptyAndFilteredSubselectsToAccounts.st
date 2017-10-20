tests-subselect
testReadCustomerWithNotEmptyAndFilteredSubselectsToAccounts

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | (eachCustomer accounts select: [:each | each id > 30]) notEmpty].
			self assert: customers size = 1.
			self assert: customers first id = 27].