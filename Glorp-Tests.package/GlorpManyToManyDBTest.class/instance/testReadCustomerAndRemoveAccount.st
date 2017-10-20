tests-read
testReadCustomerAndRemoveAccount
	self
		inTransactionDo:
			[self
				inUnitOfWorkDo:
					[| account |
					account := customer accounts detect: [:each | each id = 9874].
					customer accounts remove: account]
				initializeWith: [self writeCustomerWithAccounts].
			self readCustomer.
			accountId2 := nil.
			self checkAccounts.
			self checkNumberOfLinkRows: 2].