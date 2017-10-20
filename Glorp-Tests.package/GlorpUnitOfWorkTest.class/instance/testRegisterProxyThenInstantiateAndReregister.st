tests-registration
testRegisterProxyThenInstantiateAndReregister
	| p c |
	p := self exampleCustomerProxy.
	session beginUnitOfWork.
	session register: p.
	c := p getValue.
	session register: p.
	self assert: (session isRegistered: p).
	self assert: (session isRegistered: c).
	self assert: (session privateGetCurrentUnitOfWork privateGetTransaction 
				isRegistered: p).
	self assert: (session privateGetCurrentUnitOfWork privateGetTransaction 
				isRegistered: c)