tests-read
testReadPersonWithEmailAddresses
	| query result emailAddresses |
	self
		inTransactionDo:
			[self writePersonWithEmailAddresses.
			query := Query
				readOneOf: GlorpPerson
				where: [:eachPerson | eachPerson id = personId].
			result := query executeIn: session.
			emailAddresses := result emailAddresses getValue.
			self checkEmailAddresses: emailAddresses].