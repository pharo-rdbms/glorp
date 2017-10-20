services tables
createTableStatementStringFor: aGLORPDatabaseTable 
	"^<String> This method returns a string which can be used to create a database table ..."

	| sqlStatementStream tmpString fkeys |
	tmpString := 'create table'.
	sqlStatementStream := WriteStream on: String new.
	sqlStatementStream
		nextPutAll: (self capitalWritingOfSQLCommands 
					ifTrue: [tmpString asUppercase]
					ifFalse: [tmpString]);
		space.
	self printDDLTableNameFor: aGLORPDatabaseTable on: sqlStatementStream.

	"Now print the columns specification for each field in the table ..."
	self printColumnsSpecificationFor: aGLORPDatabaseTable
		on: sqlStatementStream.
	"Print the primary key constraint, unless using serial pkeys, since it would be a redundant declaration."
	(aGLORPDatabaseTable hasPrimaryKeyConstraints and: [aGLORPDatabaseTable primaryKeyFields first type isSerial not])
			ifTrue: [sqlStatementStream nextPutAll: ', '.
					(aGLORPDatabaseTable primaryKeyConstraints creationStringFor: self)
						do: [ :each | sqlStatementStream nextPutAll: each.]
						separatedBy: [sqlStatementStream nextPut: $,]].

	fkeys := aGLORPDatabaseTable foreignKeyConstraintsForCreation.
	fkeys notEmpty
			ifTrue: [sqlStatementStream nextPutAll: ', '.
					(fkeys collect: [:each| self createForeignKeyConstraintAddStatement: each])
						do: [ :each | sqlStatementStream nextPutAll: each first]
						separatedBy: [sqlStatementStream nextPut: $,]].

	sqlStatementStream
		nextPut: $).
	^sqlStatementStream contents