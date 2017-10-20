services tables
sqlStatementToTestExistenceOfTable: tableName inSchema: schemaString

	| stream |
	stream := WriteStream on: String new.
	self printSqlStatementToTestExistenceOfTable: tableName inSchema: schemaString on: stream.
	^stream contents