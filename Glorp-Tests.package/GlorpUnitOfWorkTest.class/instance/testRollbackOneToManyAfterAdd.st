tests
testRollbackOneToManyAfterAdd
	| customer t1 t2 transList amount |
	customer := GlorpCustomer example1.
	t1 := customer transactions first.
	t2 := customer transactions last.
	transList := customer transactions.
	amount := t1 amount.
	session beginUnitOfWork.
	session register: customer.
	20 timesRepeat: [customer addTransaction: (GlorpBankTransaction new)].
	customer transactions first amount: 65543.
	session rollbackUnitOfWork.
	self assert: customer transactions == transList.
	self assert: customer transactions size = 2.
	self assert: customer transactions first == t1.
	self assert: customer transactions last == t2.
	self assert: t1 amount == amount.