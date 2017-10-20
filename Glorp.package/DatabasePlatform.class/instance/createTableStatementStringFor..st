services tables
createTableStatementStringFor: aGLORPDatabaseTable 
	"^<String> This method returns a string which can be used to create a database table ..."

	| sqlStatementStream tmpString |
	tmpString := 'create table'.
	sqlStatementStream := WriteStream on: String new.
	sqlStatementStream
		nextPutAll: (self capitalWritingOfSQLCommands 
			ifTrue: [tmpString asUppercase]
			ifFalse: [tmpString]);
		space.
	self printDDLTableNameFor: aGLORPDatabaseTable on: sqlStatementStream.

	"Now print the columns specification for each field in the table ..."
	self 
		printColumnsSpecificationFor: aGLORPDatabaseTable
		on: sqlStatementStream.
	self supportsConstraints ifTrue:
		[aGLORPDatabaseTable hasPrimaryKeyConstraints ifTrue: 
			[sqlStatementStream nextPutAll: ', '.
			(aGLORPDatabaseTable primaryKeyConstraints creationStringFor: self)
				do: [ :each | sqlStatementStream nextPutAll: each.]
				separatedBy: [sqlStatementStream nextPut: $,]].

		aGLORPDatabaseTable hasUniqueConstraints ifTrue:
			[sqlStatementStream nextPutAll: ', '.
			aGLORPDatabaseTable uniqueConstraints do:
				[:each | sqlStatementStream nextPutAll: (each creationString)]
				separatedBy: [sqlStatementStream nextPut: $,]]].

	sqlStatementStream
		nextPut: $).
	^sqlStatementStream contents