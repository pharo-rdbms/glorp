services tables
printDDLTableNameFor: aGLORPDatabaseTable on: sqlStatementStream
	"This method just writes the name of a table to a stream, in a way appropriate for DDL statements."
	
	sqlStatementStream nextPutAll:
		(self capitalWritingOfTableName
			ifTrue: [aGLORPDatabaseTable qualifiedName asUppercase]
			ifFalse: [aGLORPDatabaseTable qualifiedName]).