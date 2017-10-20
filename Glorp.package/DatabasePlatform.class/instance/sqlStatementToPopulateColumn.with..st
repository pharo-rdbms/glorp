services columns
sqlStatementToPopulateColumn: aDatabaseField with: aValue

	| stream |

	stream := WriteStream on: String new.

	self
		printSqlStatementToPopulateColumn: aDatabaseField
		with: aValue
		on: stream.

	^ stream contents