tests-registration
testRegisterObjectWithNilCollection
	| c1 |
	c1 := GlorpCustomer new.
	c1 transactions: nil.
	session beginUnitOfWork.
	session register: c1.
	self assert: (session isRegistered: c1).