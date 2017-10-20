tests-join
testReadPersonWithJoinToEmailAddresses
	| people |
	self
		inTransactionDo:
			[self setUpSomeExtraPeople.
			people := session
				read: GlorpPerson
				where:
					[:eachPerson | 
					eachPerson emailAddresses
						anySatisfyJoin: [:eachEmail | eachEmail host = 'objectpeople.com']].
			self assert: people size = 1].