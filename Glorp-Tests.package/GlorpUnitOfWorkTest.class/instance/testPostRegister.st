tests-registration
testPostRegister
	| c1 t1 t2 |
	c1 := GlorpCustomer example2.
	[session beginTransaction.
	session beginUnitOfWork.
	t1 := GlorpBankTransaction new.
	t2 := GlorpBankTransaction new.
	c1 addTransaction: t1.
	c1 addTransaction: t2.
	session register: c1.
	self assert: (session isRegistered: c1).
	self assert: (session isRegistered: t1).
	self assert: (session isRegistered: t2).
	session commitUnitOfWork]
		ensure: [session rollbackTransaction].
	"Need some assertions on what was written"
	self unfinished.