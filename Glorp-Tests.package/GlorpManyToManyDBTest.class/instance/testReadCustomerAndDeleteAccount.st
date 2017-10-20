tests-read
testReadCustomerAndDeleteAccount
	self
		inTransactionDo:[
			[self 
				inUnitOfWorkDo: [ | account| 
					account := customer accounts detect: [:each | each id = 9874].
					session delete: account]
				initializeWith: [self writeCustomerWithAccounts]]
				on: Dialect error
				do: [:ex | Transcript show: 'integrity violation'; cr.^self].
			self readCustomer.
			accountId2 := nil.
			self checkAccounts.
			self checkNumberOfLinkRows: 2.
			self checkNumberOfAccounts: 2].