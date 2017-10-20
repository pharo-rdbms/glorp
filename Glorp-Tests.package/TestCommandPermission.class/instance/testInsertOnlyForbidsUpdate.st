tests
testInsertOnlyForbidsUpdate
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
					person name: 'Quigley Quagmire']]
		raise: GlorpIllegalCommand] ensure: [session rollbackTransaction].