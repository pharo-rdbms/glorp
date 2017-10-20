tests-read
testReadCustomerAndReplaceAccountsWithoutInstantiatingHolders
	"This works, but only fortuitously. If the accounts haven't been read into memory, we don't have to remove their object-level references to the account holder, because changing one side of the relationship in memory is enough to cause the link rows to be deleted"
	self
		inTransactionDo:
			[self
				inUnitOfWorkDo:
					[| account |
					account := GlorpBankAccount new id: 99999.
					customer accounts: (Array with: account)]
				initializeWith: [self writeCustomerWithAccounts].
			self readCustomer.
			accountId1 := 99999.
			accountId2 := nil.
			self checkAccounts.
			self checkNumberOfLinkRows: 2.
			self checkNumberOfAccounts: 4].