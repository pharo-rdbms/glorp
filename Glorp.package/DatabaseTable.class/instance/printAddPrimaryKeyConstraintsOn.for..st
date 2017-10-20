obsolete
printAddPrimaryKeyConstraintsOn: aStream for: aDatabaseAccessor 
	self primaryKeyFields isEmpty ifTrue: [^self].
	aStream nextPutAll: 'ALTER TABLE ' , self name.
	aStream nextPutAll: ' ADD CONSTRAINT '.
	aStream nextPutAll: self primaryKeyConstraintName.
	aStream nextPutAll: ' PRIMARY KEY  ('.
	GlorpHelper 
		print: [:each | each name]
		on: aStream
		for: self primaryKeyFields
		separatedBy: ','.
	aStream nextPut: $).

	aStream
		nextPutAll: ',';
		cr.

	aStream nextPutAll: ' ADD CONSTRAINT '.
	aStream nextPutAll: self primaryKeyUniqueConstraintName.
	aStream nextPutAll: ' UNIQUE  ('.
	GlorpHelper 
		print: [:each | each name]
		on: aStream
		for: self primaryKeyFields
		separatedBy: ','.
	aStream nextPut: $)