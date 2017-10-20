support
keywordForConstraintsWhenDropping: aConstraint onPlatform: aDatabasePlatform
	"This method returns the term to test against independently of #writeConstraintToDrop:onStream:.  The logic is that ANSI uses 'DROP CONSTRAINT but MySQL uses
		'DROP PRIMARY KEY' for primary key constraints (and then says don't name the constraint name in the drop statement!)
		'DROP FOREIGN KEY'  for foreign key constraints
		'DROP KEY' for unique constraints (it also supports DROP INDEX for this)"

	(aDatabasePlatform isKindOf: MySQLPlatform) ifFalse: [^'CONSTRAINT'].
	aConstraint isForeignKeyConstraint ifTrue: [^'FOREIGN KEY'].
	aConstraint isPrimaryKeyConstraint ifTrue: [^'PRIMARY KEY'].
	^'KEY'