tests-read
testReadPersonAndReplaceAdressWithProxy
	| proxy |
	self inTransactionDo: 
			[self inUnitOfWorkDo: 
					[proxy := Proxy new.
					proxy query: person address query copy.
					proxy parameters: person address parameters copy.
					proxy session: person address session.
					person address: proxy].
			self readPerson.
			self checkPerson.
			self assert: person address isGlorpProxy.
			self assert: person address getValue notNil.
			self assert: person address getValue id = 123]