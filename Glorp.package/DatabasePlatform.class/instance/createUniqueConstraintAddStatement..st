services constraints
createUniqueConstraintAddStatement: aUniqueConstraint
	"Callback from the UniqueConstraint. Returns collection of statements "
	
	| stream |
	aUniqueConstraint shouldCreateInDatabase ifFalse: [^#('')].
	stream := WriteStream on: (String new: 50).
	stream
		nextPutAll: 'CONSTRAINT ';
		nextPutAll: aUniqueConstraint name;
		nextPutAll: ' UNIQUE ('.
	GlorpHelper 
		print: [:each | each name] 
		on: stream 
		for: aUniqueConstraint fields 
		separatedBy: ','.
	stream nextPutAll: ')'.
	^OrderedCollection with: stream contents