tests
testRollbackOneToManyAfterReplace
	| customer t1 t2 transList |
	customer := GlorpCustomer example1.
	t1 := customer transactions first.
	t2 := customer transactions last.
	transList := customer transactions.
	session beginUnitOfWork.
	session register: customer.
	customer transactions: OrderedCollection new.
	session rollbackUnitOfWork.
	self assert: customer transactions == transList.
	self assert: customer transactions size = 2.
	self assert: customer transactions first == t1.
	self assert: customer transactions last == t2.