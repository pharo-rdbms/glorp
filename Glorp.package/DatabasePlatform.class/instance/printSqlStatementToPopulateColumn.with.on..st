services columns
printSqlStatementToPopulateColumn: aDatabaseField with: aValue on: aStream

	| converter dbValue |

	converter := aDatabaseField converterForStType: aValue class.
	dbValue := converter
		convert: aValue
		toDatabaseRepresentationAs: aDatabaseField type.

	aStream
		nextPutAll: 'UPDATE ';
		nextPutAll: (self ddlTableNameFor: aDatabaseField table);
		nextPutAll: ' SET ';
		nextPutAll: (self nameForColumn: aDatabaseField name);
		nextPutAll: ' = ';
		nextPutAll: dbValue printString;
		nextPutAll: ' WHERE (';
		nextPutAll: ( self nameForColumn: aDatabaseField name);
		nextPutAll: ' IS NULL OR ';
		nextPutAll: (self nameForColumn: aDatabaseField name);
		nextPutAll: ' <> ';
		nextPutAll: dbValue printString;
		nextPutAll: ')'