tests
testInsertOnlyForbidsDelete
	| person |
	[session beginTransaction.
	self writeTestRows.
	session accessor insertOnly.
	person := session readOneOf: GlorpPerson where: nil.
	self
		should:
			[session
				inUnitOfWorkDo:
					[session register: person.
					session delete: person]]
		raise: GlorpIllegalCommand] ensure: [session rollbackTransaction].