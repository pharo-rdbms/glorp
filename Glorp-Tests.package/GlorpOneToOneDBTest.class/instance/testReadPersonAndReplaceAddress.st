tests-read
testReadPersonAndReplaceAddress
	self inTransactionDo:
		[self inUnitOfWorkDo:
			[person address: ((GlorpAddress new) id: 12; street: 'foo'; number: '1234')].
		self readPerson.
		self checkPerson.
		self assert: person address isGlorpProxy.
		self assert: person address getValue id = 12.
		self assert: person address getValue street = 'foo'.].