tests-registration
testPreRegister
	
	| c1 t1 t2 trans |
	c1 := GlorpCustomer example2.
	[session beginTransaction.
	session beginUnitOfWork.
	session register: c1.
	t1 := GlorpBankTransaction new.
	t2 := GlorpBankTransaction new.
	c1 addTransaction: t1.
	c1 addTransaction: t2.
	trans := session privateGetCurrentUnitOfWork privateGetTransaction.
	session commitUnitOfWork.
	self assert: (trans isRegistered: c1).
	self assert: (trans isRegistered: t1).
	self assert: (trans isRegistered: t2).]
		ensure: [session rollbackTransaction].
	"Need some assertions on what got written"
	self unfinished.