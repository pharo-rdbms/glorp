tests
testReadPersonWithJoinWithAlsoFetch
	| people query |
	self inTransactionDo: 
			[self setUpSomeExtraPeople.
			query := ReadQuery read: GlorpPerson
						where: 
							[:eachPerson | 
							eachPerson emailAddresses anySatisfyJoin: 
									[:eachEmail | 
									eachEmail host = 'objectpeople.com' | (eachEmail host = 'cs.uiuc.edu')]].
			query alsoFetch: [:e | e address].
			people := query executeIn: session.
			self assert: people size = 1]