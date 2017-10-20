tests-read
testReadJustTheEmailAddressNotThePersonAndWriteBackWithNoChanges
	| addresses addressRows |
	"We won't have the person object to set a value for the PERSON_ID field. Ensure that we don't write a null for that field, or otherwise modify things."
	self inTransactionDo: [	
		self writePersonWithEmailAddresses.
		session beginUnitOfWork.
		addresses := session read: GlorpEmailAddress.
		self assert: ((session privateGetCache cacheForClass: GlorpPerson) at: 3 ifAbsent: [nil]) isNil.
		session commitUnitOfWork.
		addressRows := session accessor executeSQLString: 'SELECT PERSON_ID from EMAIL_ADDRESS'.
		self assert: addressRows size = 2.
		addressRows do: [:each | self assert: (each atIndex: 1) = 3].
].