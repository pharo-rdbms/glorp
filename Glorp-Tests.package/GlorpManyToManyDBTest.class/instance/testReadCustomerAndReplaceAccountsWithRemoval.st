tests-read
testReadCustomerAndReplaceAccountsWithRemoval
	self
		inTransactionDo:
			[self
				inUnitOfWorkDo:
					[| account |
					account := customer accounts detect: [:each | each id = 6].
					customer accounts: (Array with: account)]
				initializeWith: [self writeCustomerWithAccounts].
			self readCustomer.
			accountId2 := nil.
			self checkAccounts.
			self checkNumberOfLinkRows: 2].