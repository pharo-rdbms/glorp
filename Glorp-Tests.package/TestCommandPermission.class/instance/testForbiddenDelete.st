tests
testForbiddenDelete
	| person |
	[session beginTransaction.
	self writeTestRows.
	session accessor denyCommand: DeleteCommand.
	person := session readOneOf: GlorpPerson where: nil.
	self
		should:
			[session
				inUnitOfWorkDo:
					[session register: person.
					session delete: person address.
					person address: nil]]
		raise: GlorpIllegalCommand] ensure: [session rollbackTransaction].