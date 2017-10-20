setUp
createTypeTestTable
	| system |
	connection doDDLOperation: [
		connection
			dropTableNamed: self tableName
			ifAbsent: [:ex | ex return: nil].
		table := DatabaseTable named: self tableName.
		table
			createFieldNamed: 'test'
			type: type.
		(table createFieldNamed: 'id' type: session system platform inMemorySequence) bePrimaryKey.
		connection
			createTable: table
			ifError:
				[:ex | 
				Transcript show: 'CANNOT CREATE TABLE'.
             		self signalFailure: ex messageText.
				ex return: nil].
	].
	system := self systemFor: table.
	session system: system.
	^table.