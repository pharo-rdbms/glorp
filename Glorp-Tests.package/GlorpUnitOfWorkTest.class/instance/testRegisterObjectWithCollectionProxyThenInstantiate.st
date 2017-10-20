tests-registration
testRegisterObjectWithCollectionProxyThenInstantiate
	"Note that we explicitly register the objects as being old (even though they aren't) so that we don't force instantation of the related objects, which is what we're trying to test."
	| customer transactions |
	customer := self exampleCustomerWithTransactionsProxy.
	session beginUnitOfWork.
	session privateRegisterAsOld: customer.
	self deny: customer transactions isInstantiated.
	transactions := customer transactions getValue.
	self assert: customer transactions isInstantiated.
	session register: transactions.
	self assert: (session isRegistered: transactions first).
	self assert: (session isRegistered: customer).
	self assert: (session isRegistered: transactions).
	self assert: (session isRegistered: customer transactions).