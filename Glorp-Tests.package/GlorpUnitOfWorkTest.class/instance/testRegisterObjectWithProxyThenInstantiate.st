tests-registration
testRegisterObjectWithProxyThenInstantiate
	"Note that we explicitly register the objects as being old (even though they aren't) so that we don't force instantation of the related objects, which is what we're trying to test."
	| transaction customer |
	transaction := self exampleTransactionWithCustomerProxy.
	session beginUnitOfWork.
	session privateRegisterAsOld: transaction.
	self deny: transaction owner isInstantiated.
	customer := transaction owner getValue.
	session register: transaction.
	self assert: (session isRegistered: transaction).
	self assert: (session isRegistered: customer).
	self assert: (session privateGetCurrentUnitOfWork privateGetTransaction 
				isRegistered: transaction).
	self assert: (session privateGetCurrentUnitOfWork privateGetTransaction 
				isRegistered: customer).
	self assert: transaction owner isInstantiated