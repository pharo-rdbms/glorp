tests-join
testReadPersonWithNegativeJoinToEmailAddresses
	"Read with a negative condition. Note that this excludes the person with no e-mail addresses, as we're not doing an outer join"
	| people |
	self
		inTransactionDo:
			[self setUpSomeExtraPeople.
			people := session
				read: GlorpPerson
				where:
					[:eachPerson | 
					eachPerson emailAddresses
						anySatisfyJoin: [:eachEmail | eachEmail host ~= 'objectpeople.com']].
			self assert: people size = 2].