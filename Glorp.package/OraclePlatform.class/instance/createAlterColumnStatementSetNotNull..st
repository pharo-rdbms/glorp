services columns
createAlterColumnStatementSetNotNull: aField
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
		nextPutAll:  self sqlTextForNOTNULLAttributeConstraint;
		nextPutAll: ')'.

	
	^sqlStatementStream contents