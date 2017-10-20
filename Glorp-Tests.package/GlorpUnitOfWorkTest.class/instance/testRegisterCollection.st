tests-registration
testRegisterCollection
	| c1 c2 collection |
	c1 := GlorpCustomer new.
	c2 := GlorpCustomer new.
	session beginUnitOfWork.
	collection := Array with: c1 with: c2.
	session register: collection.
	self assert: (session isRegistered: c1).
	self assert: (session isRegistered: collection).