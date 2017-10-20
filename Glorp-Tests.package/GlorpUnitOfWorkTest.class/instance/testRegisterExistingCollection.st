tests-registration
testRegisterExistingCollection
	| c1 |
	c1 := GlorpCustomer new.
	session beginUnitOfWork.
	session register: c1.
	session register: c1 transactions.
	self assert: (session isRegistered: c1).
	self assert: (session isRegistered: c1 transactions).
	self deny: (session isNew: c1 transactions).