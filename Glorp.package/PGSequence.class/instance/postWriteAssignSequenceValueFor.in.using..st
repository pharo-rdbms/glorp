SQL
postWriteAssignSequenceValueFor: aDatabaseField in: aDatabaseRow using: anAccessor

"No-op;  for user information, we show, commented, the code that was provided here circa Glorp 0.2.*.
	aDatabaseRow at: aDatabaseField
		put: (aSession accessor 
				executeSQLString: 'SELECT CURRVAL(' , self qualifiedName 	, ')')."