tests-write
testWriteCustomerWithTwoAccounts
	| newCustomer |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			session beginUnitOfWork.
			newCustomer := GlorpCustomer example1.
			newCustomer id: 12.
			customerId := 12.
			newCustomer accounts: (OrderedCollection with: (GlorpBankAccount new id: 223)).
			newCustomer accounts add: (GlorpBankAccount new id: 224).
			session register: newCustomer.
			session commitUnitOfWork.
			session reset.
			self readCustomer.
			accountId1 := 223.
			accountId2 := 224.
			self checkAccounts.
			self checkNumberOfAccounts: 5.
			self checkNumberOfLinkRows: 5].