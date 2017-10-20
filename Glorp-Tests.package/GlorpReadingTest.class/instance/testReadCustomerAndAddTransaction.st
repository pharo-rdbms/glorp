tests
testReadCustomerAndAddTransaction
	| query  customer accountIds newCustomer rawRows |
	
	[session beginTransaction.
	accountIds := self writeCustomer1Rows.
	session beginUnitOfWork.
	query := Query readOneOf: GlorpCustomer
				where: [:person | person id = 27].
	customer := session execute: query.
	customer addTransaction: GlorpBankTransaction example1.
	session commitUnitOfWork.
	newCustomer := session execute: query.
	self assert: customer == newCustomer.
	self assert: customer transactions first owner yourSelf == customer.
	rawRows := session accessor executeSQLString: 'SELECT ID, NAME FROM GR_CUSTOMER'.
	self assert: rawRows size = 1.
	self assert: (rawRows first atIndex: 1) = 27.
	] 
			ensure: [session rollbackTransaction]