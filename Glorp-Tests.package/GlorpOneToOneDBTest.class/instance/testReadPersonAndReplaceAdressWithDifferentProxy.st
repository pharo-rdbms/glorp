tests-read
testReadPersonAndReplaceAdressWithDifferentProxy
	| proxy |
	self inTransactionDo: 
			[
			session writeRow: session system exampleAddressRowForOrdering1.
			self inUnitOfWorkDo: 
					[ | field |
					proxy := Proxy new.
					proxy query: person address query copy.
					field := (session system tableNamed: 'PERSON') fieldNamed: 'ADDRESS_ID'.
					proxy parameters: (IdentityDictionary new at: field put: 1; yourself).
					proxy session: person address session.
					person address: proxy].
			self readPerson.
			self checkPerson.
			self assert: person address isGlorpProxy.
			self assert: person address getValue notNil.
			self assert: person address getValue id = 1]