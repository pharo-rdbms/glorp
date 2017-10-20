services columns
createDropColumnStatementFor: aField
	| stream |
	stream := WriteStream on: String new.
	stream 
		nextPutAll: 'ALTER TABLE';
		space.
	self printDDLTableNameFor: aField table  on: stream.
	stream
		space;
		nextPutAll: 'DROP COLUMN';
		space;
		nextPutAll: (self nameForColumn: aField name).
		
	^stream contents