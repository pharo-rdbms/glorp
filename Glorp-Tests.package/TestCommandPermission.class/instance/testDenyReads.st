tests
testDenyReads
	| person address |
	[session beginTransaction.
	self writeTestRows.
	person := session readOneOf: GlorpPerson where: nil.
	address := person address yourSelf.
	session accessor denyReads.
	self should: [session readOneOf: GlorpPerson where: nil] raise: GlorpIllegalCommand.
	session inUnitOfWorkDo: [
		session register: person.
		session delete: address.
		person address: (GlorpAddress new id: 7).
		person name: 'Quigley Quagmire']]
	ensure: [session rollbackTransaction].