services columns
sqlStatementToCopyDataFromColumn: fromDatabaseField to: toDatabaseField

	| stream |

	stream := WriteStream on: String new.

	self
		printSqlStatementToCopyDataFromColumn: fromDatabaseField
		to: toDatabaseField
		on: stream.

	^ stream contents