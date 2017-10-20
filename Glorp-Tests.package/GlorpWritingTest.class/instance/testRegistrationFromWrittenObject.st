tests
testRegistrationFromWrittenObject
	| customer trans transactions |
	session beginTransaction.
	[customer := GlorpCustomer new.
	customer name: 'foo'.
     customer id: 123.
	session beginUnitOfWork.
	session register: customer.
	session commitUnitOfWork.
	trans := GlorpBankTransaction new.
	session beginUnitOfWork.
	session readOneOf: GlorpCustomer where: [:each | each id = customer id].
	customer addTransaction: trans.
	session commitUnitOfWork.
	transactions := session accessor executeSQLString: 'SELECT ID FROM BANK_TRANS WHERE OWNER_ID = ', customer id printString.
	self assert: transactions size = 1.
	self assert: (trans id = (transactions first atIndex: 1))]
		ensure: [session rollbackTransaction].