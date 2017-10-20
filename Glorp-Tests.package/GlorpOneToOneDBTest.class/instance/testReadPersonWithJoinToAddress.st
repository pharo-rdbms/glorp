tests-join
testReadPersonWithJoinToAddress
	| people |
	self inTransactionDo: [
		self writePersonWithAddress.
		people := session read: GlorpPerson where: [:eachPerson | eachPerson address street = 'Paseo Montril'].
		self assert: people size = 1.
		person := people first.
		self assert: person address street = 'Paseo Montril'.
		self assert: person address id = 123].