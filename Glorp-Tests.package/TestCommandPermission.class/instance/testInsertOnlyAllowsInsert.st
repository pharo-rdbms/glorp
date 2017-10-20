tests
testInsertOnlyAllowsInsert
	| person |
	[session beginTransaction.
	self writeTestRows.
	session accessor insertOnly.
	person := session readOneOf: GlorpPerson where: nil.
	session
		inUnitOfWorkDo:
			[session register: person.
			session register: (GlorpPerson new id: 4)]]
		ensure: [session rollbackTransaction].