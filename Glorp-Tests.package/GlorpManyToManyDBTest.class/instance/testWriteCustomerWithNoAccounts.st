tests-write
testWriteCustomerWithNoAccounts
	| newCustomer |
	self
		inTransactionDo:
			[session beginUnitOfWork.
			newCustomer := GlorpCustomer example1.
			newCustomer id: 12.
			customerId := 12.
			session register: newCustomer.
			session commitUnitOfWork.
			session reset.
			self readCustomer.
			accountId1 := nil.
			accountId2 := nil.
			self checkAccounts.
			self checkNumberOfAccounts: 0.
			self checkNumberOfLinkRows: 0].