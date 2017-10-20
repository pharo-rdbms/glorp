tests-join
testReadPersonWithSubselectToEmailAddresses
	| people |
	self
		inTransactionDo:
			[self setUpSomeExtraPeople.
			people := session
				read: GlorpPerson
				where:
					[:eachPerson | 
					eachPerson emailAddresses
						anySatisfyExists: [:eachEmail | eachEmail host = 'objectpeople.com']].
			self assert: people size = 1].