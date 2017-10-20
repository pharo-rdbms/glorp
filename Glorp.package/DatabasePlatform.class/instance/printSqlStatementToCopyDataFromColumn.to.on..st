services columns
printSqlStatementToCopyDataFromColumn: fromColumn to: toColumn on: aStream
	"
	Example:
	UPDATE test_bank_acct
	SET close_balance = balance
	WHERE close_balance IS NULL OR close_balance <> balance
	"
	| toColumnName fromColumnName |
	toColumnName := self nameForColumn: toColumn name.
	fromColumnName := self nameForColumn: fromColumn name.
	aStream
		nextPutAll: 'UPDATE ';
		nextPutAll: (self ddlTableNameFor: fromColumn table);
		nextPutAll: ' SET ';
		nextPutAll: toColumnName;
		nextPutAll: ' = ';
		nextPutAll: fromColumnName;
		nextPutAll: ' WHERE ';
		nextPutAll: toColumnName;
		nextPutAll: ' IS NULL OR ';
		nextPutAll: toColumnName;
		nextPutAll: ' <> ';
		nextPutAll: fromColumnName