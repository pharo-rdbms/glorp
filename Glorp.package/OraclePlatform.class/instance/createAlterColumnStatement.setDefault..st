services columns
createAlterColumnStatement: aField setDefault: anObject
	| sqlStatementStream |
	sqlStatementStream := WriteStream on: String new.
	sqlStatementStream
		nextPutAll:  'ALTER TABLE';
		space.
	self printDDLTableNameFor: aField table on: sqlStatementStream.

	sqlStatementStream
		nextPutAll:  ' MODIFY (';
		space;
		nextPutAll: (self nameForColumn: aField name);
		space;
		nextPutAll:  'DEFAULT';
		space.
	anObject printOn: sqlStatementStream.
	sqlStatementStream
		nextPutAll:  ')'.
	
	^sqlStatementStream contents