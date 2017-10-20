tests
testMultipleWritesAndReads
	"Trying to narrow down on a problem with SQLiteEXDI"

	| names customers |
	session beginTransaction.
	[session beginUnitOfWork.
	names := OrderedCollection new.
	1 to: 10
		do: 
			[:i | 
			| nm |
			nm := 'John Doe ' , i printString.
			names add: nm.
			session register: ((GlorpCustomer new)
									id: i;
									name: nm;
									yourself)].
	session commitUnitOfWork.
	customers := session read: GlorpCustomer.
	self assert: (names asSortedCollection hasEqualElements: (customers collect: [:ea | ea name]) asSortedCollection).
	] 
			ensure: [session rollbackTransaction]