services tables
printSqlStatementToRenameTable: aDatabaseTable to: newTableName on: aStream
	" Tje default SQL statement is
	ALTER TABLE <oldTableName> RENAME TO <newTableName>.
	Different platforms may use another form. Override in subclasses if necessary.
	"

	aStream
		nextPutAll: 'ALTER TABLE ';
		nextPutAll: (self ddlTableNameFor: aDatabaseTable);
		nextPutAll: ' RENAME TO ';
		nextPutAll: newTableName