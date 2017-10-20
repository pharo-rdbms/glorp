tests-registration
testRegisterObjectWithInstantiatedProxy
	| transaction customer |
	transaction := self exampleTransactionWithCustomerProxy.
	customer := transaction owner getValue.
	session beginUnitOfWork.
	session register: transaction.
	self assert: (session isRegistered: transaction).
	self assert: (session isRegistered: customer).
	self assert: (session privateGetCurrentUnitOfWork privateGetTransaction 
				isRegistered: transaction).
	self assert: (session privateGetCurrentUnitOfWork privateGetTransaction 
				isRegistered: customer).
	self assert: transaction owner isInstantiated.