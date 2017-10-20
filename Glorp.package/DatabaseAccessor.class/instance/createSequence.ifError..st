executing
createSequence: aDatabaseSequence ifError: aBlock 

	self
		executeInDDLOperation: [ self executeSQLStringNoResult: aDatabaseSequence creationString]
		ifError: aBlock