services tables
createTableIndexStatementStringsFor: aGLORPDatabaseTable
	^aGLORPDatabaseTable indexes
		collect:
			[:idx | 
			| sqlStatementStream |
			sqlStatementStream := WriteStream on: String new.
			sqlStatementStream nextPutAll: 'CREATE INDEX '.
			sqlStatementStream nextPutAll: idx name.
			sqlStatementStream nextPutAll: ' ON '.
			self printDDLTableNameFor: aGLORPDatabaseTable on: sqlStatementStream.
			idx printStatementOn: sqlStatementStream.
			sqlStatementStream contents].