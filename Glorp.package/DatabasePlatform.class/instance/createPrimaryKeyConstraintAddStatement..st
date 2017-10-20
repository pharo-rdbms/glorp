services constraints
createPrimaryKeyConstraintAddStatement: aPrimaryKeyConstraint
	"Callback from the PrimaryKeyConstraint. Returns collection of statements "
	| aStream statements |
	aPrimaryKeyConstraint shouldCreateInDatabase ifFalse: [^''].
	statements := OrderedCollection new.
	aStream := WriteStream on: String new.
	aStream nextPutAll: 'CONSTRAINT '.
	aStream nextPutAll: aPrimaryKeyConstraint name.
	aStream nextPutAll: ' PRIMARY KEY  ('.
	GlorpHelper 
		print: [:each | each name]
		on: aStream
		for: aPrimaryKeyConstraint primaryKeyFields
		separatedBy: ','.
	aStream nextPut: $).
	statements add: aStream contents.
	self primaryKeysAreAutomaticallyUnique ifTrue: [^statements].

	aStream reset.
	aStream nextPutAll: ' CONSTRAINT '.
	aStream nextPutAll: (self usesPrimaryKeyUniqueConstraintNames 
							ifTrue: [aPrimaryKeyConstraint table name, '_UNIQ'] 
							ifFalse: ['']).
	aStream nextPutAll: ' UNIQUE  ('.
	GlorpHelper 
		print: [:each | each name]
		on: aStream
		for: aPrimaryKeyConstraint  primaryKeyFields
		separatedBy: ','.
	aStream nextPut: $).
	statements add: aStream contents.

	^statements