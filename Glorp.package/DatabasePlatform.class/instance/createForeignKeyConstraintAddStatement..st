services constraints
createForeignKeyConstraintAddStatement: aForeignKeyConstraint
	"Callback from the ForeignKeyConstraint. Returns collection of statements "
	| ws |
	aForeignKeyConstraint shouldCreateInDatabase ifFalse: [^#('')].
	ws := WriteStream on: (String new: 50).
	ws
		nextPutAll: 'CONSTRAINT ';
		nextPutAll: aForeignKeyConstraint name;
		nextPutAll: ' FOREIGN KEY ('.
	GlorpHelper print: [:each | each name] on: ws for: aForeignKeyConstraint sourceFields separatedBy: ','.
	ws 	nextPutAll: ') REFERENCES ';
		nextPutAll: aForeignKeyConstraint targetTable qualifiedName;
		nextPutAll: ' ('.
	GlorpHelper print: [:each | each name] on: ws for: aForeignKeyConstraint targetFields separatedBy: ','.
	ws nextPutAll: ')'.
	aForeignKeyConstraint suffixExpression isNil
		ifFalse:
			[ws
				space;
				nextPutAll: aForeignKeyConstraint suffixExpression].

	^OrderedCollection with: ws contents.