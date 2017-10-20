tests
testReadPersonWithExistsWithAlsoFetch
	| people query |
	self inTransactionDo: 
			[self setUpSomeExtraPeople.
			query := ReadQuery read: GlorpPerson
						where: 
							[:eachPerson | 
							eachPerson emailAddresses 
								anySatisfyExists: [:eachEmail | eachEmail host = 'objectpeople.com']].
			query alsoFetch: [:e | e address].
			people := query executeIn: session.
			self assert: people size = 1]