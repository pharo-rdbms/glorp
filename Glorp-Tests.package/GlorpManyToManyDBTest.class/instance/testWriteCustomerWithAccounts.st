tests-write
testWriteCustomerWithAccounts
	| newCustomer |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			session beginUnitOfWork.
			newCustomer := GlorpCustomer example1.
			newCustomer id: 12.
			customerId := 12.
			newCustomer accounts: (OrderedCollection with: (GlorpBankAccount new id: 223)).
			session register: newCustomer.
			session commitUnitOfWork.
			session reset.
			self readCustomer.
			accountId1 := 223.
			accountId2 := nil.
			self checkAccounts.
			self checkNumberOfAccounts: 4.
			self checkNumberOfLinkRows: 4].