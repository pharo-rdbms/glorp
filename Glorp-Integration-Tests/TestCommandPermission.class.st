Class {
	#name : #TestCommandPermission,
	#superclass : #GlorpSessionBasedTest,
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #tests }
TestCommandPermission >> testAlsoDeny [
	| person |
	[session beginTransaction.
	self writeTestRows.
	session accessor denyCommand: InsertCommand.
	session accessor alsoDenyCommand: DeleteCommand.
	person := session readOneOf: GlorpPerson where: nil.
	self
		should:
			[session
				inUnitOfWorkDo:
					[session register: person.
					session delete: person]]
		raise: GlorpIllegalCommand] ensure: [session rollbackTransaction].
]

{ #category : #tests }
TestCommandPermission >> testDenyReads [
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
]

{ #category : #tests }
TestCommandPermission >> testForbiddenDelete [
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
]

{ #category : #tests }
TestCommandPermission >> testForbiddenDeleteAllowsUpdateAndInsert [
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
]

{ #category : #tests }
TestCommandPermission >> testInsertOnlyAllowsInsert [
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
]

{ #category : #tests }
TestCommandPermission >> testInsertOnlyForbidsDelete [
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
]

{ #category : #tests }
TestCommandPermission >> testInsertOnlyForbidsUpdate [
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
]

{ #category : #tests }
TestCommandPermission >> testPermitEverything [
	session accessor permitEverything.
	[session beginTransaction.
	self writeTestRows.
	session inUnitOfWorkDo: [ | person |
		person := session readOneOf: GlorpPerson where: nil.
		session delete: person address.
		person address: (GlorpAddress new id: 7).
		person name: 'Quigley Quagmire']]
	ensure: [session rollbackTransaction].
]

{ #category : #tests }
TestCommandPermission >> testPermitNothing [
	session accessor permitNothing.
	self should: [session read: GlorpPerson] raise: GlorpIllegalCommand.
	self
		should:
			[session accessor executeCommand: InsertCommand new]
		raise: GlorpIllegalCommand.
	self
		should:
			[session accessor executeCommand: UpdateCommand new]
		raise: GlorpIllegalCommand.
	self
		should:
			[session accessor executeCommand: DeleteCommand new]
		raise: GlorpIllegalCommand.
	self
		should:
			[session accessor
				executeCommand: SQLStringSelectCommand new]
		raise: GlorpIllegalCommand.
]

{ #category : #tests }
TestCommandPermission >> testReadOnlyForbidsDelete [
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
					session delete: person]]
		raise: GlorpIllegalCommand] ensure: [session rollbackTransaction].
]

{ #category : #tests }
TestCommandPermission >> testReadOnlyForbidsInsert [
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
]

{ #category : #tests }
TestCommandPermission >> testReadOnlyForbidsUpdate [
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
]

{ #category : #support }
TestCommandPermission >> writeTestRows [
	| addressRow personRow |
	addressRow := session system exampleAddressRow.
	session writeRow: addressRow.
	personRow := session system examplePersonRow1.
	session writeRow: personRow.
]
