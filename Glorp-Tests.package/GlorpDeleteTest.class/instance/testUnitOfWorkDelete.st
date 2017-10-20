tests
testUnitOfWorkDelete
	| customer result |
	
	[customer := self setUpCustomer.
	session beginUnitOfWork.
	session delete: customer.
	result := session accessor 
				executeSQLString: 'SELECT * FROM GR_CUSTOMER WHERE ID=1'.
	self assert: result size = 1.
	self 
		assert: (session readOneOf: GlorpCustomer where: [:each | each id = 1]) isNil.
	self checkCustomerStillInCache.
	session commitUnitOfWork.
	self checkCustomerNotInCache.
	self checkCustomerDeletedInDatabase] 
			ensure: [session rollbackTransaction]