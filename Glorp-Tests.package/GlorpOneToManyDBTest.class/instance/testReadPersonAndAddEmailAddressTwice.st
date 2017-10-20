tests-read
testReadPersonAndAddEmailAddressTwice
	| personRow addressRow |
	self
		inTransactionDo:
			[self
				inUnitOfWorkDo:
					[person emailAddresses
						add:
							((GlorpEmailAddress new)
								id: 99876;
								user: 'postmaster';
								host: 'foo.com')]
				initializeWith:
					[addressRow := session system exampleAddressRow.
					session writeRow: addressRow.
					personRow := session system examplePersonRow1.
					personId := personRow atFieldNamed: 'ID'.
					session writeRow: personRow].
			self
				inUnitOfWorkDo:
					[person emailAddresses
						add:
							((GlorpEmailAddress new)
								id: 99991;
								user: 'someone';
								host: 'foo.com')]
				initializeWith: [].
			emailId1 := 99876.
			emailId2 := 99991.
			self readPerson.
			self checkEmailAddresses: person emailAddresses].