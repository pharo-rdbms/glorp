tests-read
testReadPersonWithIsEmptySubselectToEmailAddresses
	| people |
	self
		inTransactionDo:
			[self setUpSomeExtraPeople.
			people := session
				read: GlorpPerson
				where:
					[:eachPerson | eachPerson emailAddresses isEmpty].
			self assert: people size = 1].