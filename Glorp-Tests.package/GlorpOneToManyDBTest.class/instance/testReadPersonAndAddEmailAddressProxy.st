tests-read
testReadPersonAndAddEmailAddressProxy
	| address |
	self
		inTransactionDo:
			[self
				inUnitOfWorkDo:
					[| query |
					query := Query
						readOneOf: GlorpEmailAddress
						where: [:each | each id = 99876].
					query proxyType: Proxy.
					address := session execute: query.
					address yourself.
					person emailAddresses add: address.
					self assert: person emailAddresses last class == Proxy]
				initializeWith:
					[self writePersonWithEmailAddresses.
					session
						transact:
							[(GlorpEmailAddress new)
								id: 99876;
								user: 'postmaster';
								host: 'foo.com'].
						session reset].
			emailId3 := 99876.
			self readPerson.
			self checkEmailAddresses: person emailAddresses].