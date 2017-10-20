services columns
createAddColumnStatementFor: aField
	| stream |
	stream := WriteStream on: String new.
	stream 
		nextPutAll: 'ALTER TABLE';
		space.
	self printDDLTableNameFor: aField table on: stream.
	stream
		space;
		nextPutAll: ' ADD ';
		nextPutAll: self startColumnAddString.
	self  printColumn: aField on: stream.
	stream nextPutAll: self  endColumnAddString.
		
	^stream contents