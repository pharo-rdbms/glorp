tests-read
testReadPersonWithNotEmptySubselectToEmailAddresses
	| people |
	self
		inTransactionDo:
			[self setUpSomeExtraPeople.
			people := session
				read: GlorpPerson
				where:
					[:eachPerson | eachPerson emailAddresses notEmpty].
			self assert: people size = 2].