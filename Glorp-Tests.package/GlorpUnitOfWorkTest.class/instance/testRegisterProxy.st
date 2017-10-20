tests-registration
testRegisterProxy
	| p |
	p := self exampleCustomerProxy.
	session beginUnitOfWork.
	session register: p.
	self deny: (session isRegistered: p).
	self deny: (session isRegistered: p query result).
	p getValue.
	self assert: (session isRegistered: p).
	self assert: (session isRegistered: p query result).