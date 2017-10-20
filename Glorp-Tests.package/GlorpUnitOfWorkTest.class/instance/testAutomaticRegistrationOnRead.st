tests
testAutomaticRegistrationOnRead
	| p c |
	p := self exampleCustomerProxy.
	c := p getValue.
	session beginUnitOfWork.
	session register: p.
	self assert: (session isRegistered: p).
	self assert: (session isRegistered: c).
	self assert: (session privateGetCurrentUnitOfWork privateGetTransaction isRegistered: p).
	self assert: (session privateGetCurrentUnitOfWork privateGetTransaction isRegistered: c).