services tables
sqlStatementToRenameTable: aDatabaseTable to: newTableName

	| stream |

	stream := WriteStream on: String new.

	self printSqlStatementToRenameTable: aDatabaseTable to: newTableName on: stream.

	^ stream contents