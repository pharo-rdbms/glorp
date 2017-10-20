tests-read
testReadCustomerAndDeleteAccountProperly
	"Do both the delete and the patching up of relationships"
	self
		inTransactionDo:
			[
			self 
				inUnitOfWorkDo: [ | account| 
					account := customer accounts detect: [:each | each id = 9874].
					session delete: account.
					customer removeAccount: account]
				initializeWith: [self writeCustomerWithAccounts].
			self readCustomer.
			accountId2 := nil.
			self checkAccounts.
			self checkNumberOfLinkRows: 2.
			self checkNumberOfAccounts: 2].