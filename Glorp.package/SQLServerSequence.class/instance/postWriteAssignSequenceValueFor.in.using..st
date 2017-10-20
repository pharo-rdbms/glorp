sequencing
postWriteAssignSequenceValueFor: aDatabaseField in: aDatabaseRow using: anAccessor 
	aDatabaseRow at: aDatabaseField
		put: ((anAccessor 
				executeSQLString: 'SELECT @@IDENTITY') first at: 1).