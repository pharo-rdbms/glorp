services columns
sqlStatementToCopyDataFromTable: fromDatabaseTable to: toDatabaseTable

	| stream |

	stream := WriteStream on: String new.

	self
		printSqlStatementToCopyDataFromTable: fromDatabaseTable
		to: toDatabaseTable
		on: stream.

	^ stream contents