tests
testPermitEverything
	session accessor permitEverything.
	[session beginTransaction.
	self writeTestRows.
	session inUnitOfWorkDo: [ | person |
		person := session readOneOf: GlorpPerson where: nil.
		session delete: person address.
		person address: (GlorpAddress new id: 7).
		person name: 'Quigley Quagmire']]
	ensure: [session rollbackTransaction].