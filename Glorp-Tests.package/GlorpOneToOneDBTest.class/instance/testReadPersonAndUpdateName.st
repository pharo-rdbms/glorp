tests-read
testReadPersonAndUpdateName
	"Test to make sure that if we never instantiate the address, we don't have problems with that relationship."

	self inTransactionDo:
		[self inUnitOfWorkDo: [person name: 'new name'].
		self deny: person address isInstantiated.
		session reset.
		self readPerson.
		self assert: person name = 'new name'.
		self assert: person address isGlorpProxy.
		self assert: person address getValue id = 123.
		self assert: person address getValue street = 'Paseo Montril'].