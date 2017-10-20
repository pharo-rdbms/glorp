services columns
printSqlStatementToRenameColumn: oldColumn to: newColumnName on: aStream

	aStream
		nextPutAll: 'ALTER TABLE ';
		nextPutAll: (self ddlTableNameFor: oldColumn table);
		nextPutAll: ' RENAME ';
		nextPutAll:  (self nameForColumn:  oldColumn name);
		nextPutAll: ' TO ';
		nextPutAll:  (self nameForColumn: newColumnName).