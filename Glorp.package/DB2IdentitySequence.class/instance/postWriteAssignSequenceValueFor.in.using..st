sequencing
postWriteAssignSequenceValueFor: aDatabaseField in: aDatabaseRow using: anAccessor 
	aDatabaseRow at: aDatabaseField
		put: (((anAccessor 
				executeSQLString: 'VALUES IDENTITY_VAL_LOCAL()') first atIndex: 1) asInteger).