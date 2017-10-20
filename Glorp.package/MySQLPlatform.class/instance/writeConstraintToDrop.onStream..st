services constraints
writeConstraintToDrop: aConstraint onStream: aStream
	"Return the term we use to describe a constraint when dropping them.  This is required because MySQL wants you to use
		'DROP PRIMARY KEY' for primary key constraints (and then says don't name the constraint name in the drop statement!)
		'DROP FOREIGN KEY'  for foreign key constraints
		'DROP KEY' for unique constraints (it also supports DROP INDEX for this)
	rather than the ANSI 'DROP CONSTRAINT'."

	aConstraint isForeignKeyConstraint ifTrue: [aStream nextPutAll: 'FOREIGN KEY'].
	aConstraint isPrimaryKeyConstraint ifTrue: [aStream nextPutAll: 'PRIMARY KEY'].
	aConstraint isUniqueConstraint ifTrue: [aStream nextPutAll: 'KEY'].
	aConstraint isPrimaryKeyConstraint ifFalse:
		[aStream
			nextPut: $ ;
			nextPutAll: aConstraint name].