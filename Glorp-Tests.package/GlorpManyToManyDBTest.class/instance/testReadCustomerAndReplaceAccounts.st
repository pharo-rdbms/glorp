tests-read
testReadCustomerAndReplaceAccounts
	self
		inTransactionDo:
			[self
				inUnitOfWorkDo:
					[| account |
					account := GlorpBankAccount new id: 99999.
					customer accounts do: [:each | each accountHolders remove: customer].
					customer accounts: (Array with: account)]
				initializeWith: [self writeCustomerWithAccounts].
			self readCustomer.
			accountId1 := 99999.
			accountId2 := nil.
			self checkAccounts.
			self checkNumberOfLinkRows: 2.
			self checkNumberOfAccounts: 4].