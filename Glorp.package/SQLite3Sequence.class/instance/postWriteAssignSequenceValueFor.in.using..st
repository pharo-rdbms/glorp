sequencing
postWriteAssignSequenceValueFor: aDatabaseField in: aDatabaseRow using: anAccessor
	
	| value |
	value := (anAccessor executeSQLString: 'SELECT last_insert_rowid()') first at: 1.
	aDatabaseRow at: aDatabaseField put: value