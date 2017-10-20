tests
testRollbackOneToOneWithProxy
	| transaction customerProxy |
	transaction := self exampleTransactionWithCustomerProxy.
	customerProxy := transaction owner.
	session beginUnitOfWork.
	session register: transaction.
	transaction owner: GlorpCustomer new.
	session rollbackUnitOfWork.
	self assert: transaction owner == customerProxy