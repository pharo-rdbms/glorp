tests
testWriteObjectWithNilCollection
	| c1 query customer |
	c1 := GlorpCustomer new.
	c1 transactions: nil.
	c1 id: 9999.
	[session beginTransaction.
	session beginUnitOfWork.
	session register: c1.
	session commitUnitOfWork.
	query := Query readOneOf: GlorpCustomer where: [:each | each id = 9999].
	query shouldRefresh: true.
	customer := session execute: query.
	self assert: customer transactions notNil.
	self assert: customer transactions isEmpty.
	]
		ensure: [session rollbackTransaction].