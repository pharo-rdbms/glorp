executing
dropSequence: aDatabaseSequence ifAbsent: aBlock 
	self
		executeInDDLOperation: [ self executeSQLStringNoResult: aDatabaseSequence dropString ]
		ifError: aBlock