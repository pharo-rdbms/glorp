services columns
createAlterColumnStatement: aField newType: aType usingExpression: expression

	| sqlStatementStream |
	sqlStatementStream := WriteStream on: String new.
	sqlStatementStream
		nextPutAll:  'ALTER TABLE';
		space.
	self printDDLTableNameFor: aField table on: sqlStatementStream.

	sqlStatementStream
		nextPutAll:  ' ALTER COLUMN';
		space;
		nextPutAll: (self nameForColumn: aField name);
		space;
		nextPutAll:  ' TYPE ';
		nextPutAll: aType typeString.
	expression ifNotNil: [ sqlStatementStream nextPutAll: ' USING ', expression ].

	^sqlStatementStream contents