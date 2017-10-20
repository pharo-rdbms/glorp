tests
testForbiddenDeleteAllowsUpdateAndInsert
	| person |
	[session beginTransaction.
	self writeTestRows.
	session accessor denyCommand: DeleteCommand.
	person := session readOneOf: GlorpPerson where: nil.
	session inUnitOfWorkDo: [
		session register: person.
		person address: (GlorpAddress new id: 7).
		person name: 'Quigley Quagmire']]
	ensure: [session rollbackTransaction].