tests
testReadOnlyForbidsInsert
	| person |
	[session beginTransaction.
	self writeTestRows.
	session accessor denyWrites.
	person := session readOneOf: GlorpPerson where: nil.
	self
		should:
			[session
				inUnitOfWorkDo:
					[session register: person.
					person address: (GlorpAddress new id: 7)]]
		raise: GlorpIllegalCommand] ensure: [session rollbackTransaction].