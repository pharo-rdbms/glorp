tests
testDuplicateDetection
	| customer customer2 |
	session beginUnitOfWork.
	customer := self addCustomerToCache.
	customer2 := customer copy.
	self should: [session register: customer2] raise: Dialect error.
	session rollbackUnitOfWork.