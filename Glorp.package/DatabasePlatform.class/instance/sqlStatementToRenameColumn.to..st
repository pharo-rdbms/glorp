services columns
sqlStatementToRenameColumn: oldColumn to: newColumnName

	| stream |

	stream := WriteStream on: String new.

	self
		printSqlStatementToRenameColumn: oldColumn
		to: newColumnName
		on: stream.

	^ stream contents