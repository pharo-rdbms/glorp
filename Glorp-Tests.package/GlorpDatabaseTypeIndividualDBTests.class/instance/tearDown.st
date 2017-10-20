setUp
tearDown
	super tearDown.
	session doDDLOperation: [
		connection
			dropTableNamed: self tableName
			ifAbsent: [:ex | ex return: nil]].
	session reset.
	session := nil.