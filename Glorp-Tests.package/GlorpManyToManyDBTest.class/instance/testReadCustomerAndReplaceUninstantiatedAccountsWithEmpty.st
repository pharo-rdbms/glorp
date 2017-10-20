tests-read
testReadCustomerAndReplaceUninstantiatedAccountsWithEmpty
	self
		inTransactionDo:
			[self
				inUnitOfWorkDo:
					[customer accounts: #()]
				initializeWith: [self writeCustomerWithAccounts].
			self readCustomer.
			accountId1 := nil.
			accountId2 := nil.
			self checkAccounts.
			self checkNumberOfLinkRows: 1.
			self checkNumberOfAccounts: 3].