tests
testRollbackOneToOne
	| transaction customer |
	transaction := GlorpBankTransaction new.
	customer := GlorpCustomer new.
	transaction owner: customer.
	session beginUnitOfWork.
	session register: transaction.
	transaction owner: GlorpCustomer new.
	session rollbackUnitOfWork.
	self assert: transaction owner == customer.