tests-read
testReadCustomerAndAddAccount
	self
		inTransactionDo:
			[
			self 
				inUnitOfWorkDo: [customer addAccount: (GlorpBankAccount new id: 77473)]
				initializeWith: [self writeCustomerWithAccounts].
			self readCustomer.
			accountId3 := 77473.
			self checkAccounts.
			self checkNumberOfLinkRows: 4].