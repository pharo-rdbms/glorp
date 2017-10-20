services tables
createDropTableStatementFor: aTableNameString
	"^<String> This method returns a string which can be used to drop a database table ..."

	| sqlStatementStream |
	sqlStatementStream := WriteStream on: String new.
	sqlStatementStream
		nextPutAll: 'DROP TABLE';
		space;
		nextPutAll: aTableNameString.

	^sqlStatementStream contents