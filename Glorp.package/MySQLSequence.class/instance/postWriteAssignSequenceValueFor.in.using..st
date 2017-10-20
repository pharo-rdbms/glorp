sequencing
postWriteAssignSequenceValueFor: aDatabaseField in: aDatabaseRow using: anAccessor 
	aDatabaseRow at: aDatabaseField
		put: ((anAccessor 
				executeSQLString: 'SELECT LAST_INSERT_ID()') first at: 1).