tests
testFunctionalInsertUpdateForInsert

	| testObject |
	[session beginTransaction.
	session beginUnitOfWork.
	testObject := GlorpCustomer example1.
	testObject id: 876.
	session register: testObject.
	session commitUnitOfWork.
	self assert: (testObject seenPreWrite = true).
	self assert: (testObject seenPostWrite = true).

	session beginUnitOfWork.
	session register: testObject.
	testObject name: 'Change of name'.
	session commitUnitOfWork]
		ensure: [session rollbackTransaction]