services tables
sqlStatementToListTablesInSchema: schemaString

	| stream |
	stream := WriteStream on: String new.
	self printSqlStatementToListTablesInSchema: schemaString on: stream.
	^stream contents