tests
testRegisteringWithEmbeddedMapping

	| bankTrans |
	session beginUnitOfWork.
	bankTrans := self helperForTestReadEmbeddedOneToOne.
	self assert: (session isRegistered: bankTrans).
	self assert: (session isRegistered: bankTrans serviceCharge).
	self assert: (session isRegistered: bankTrans serviceCharge amount).