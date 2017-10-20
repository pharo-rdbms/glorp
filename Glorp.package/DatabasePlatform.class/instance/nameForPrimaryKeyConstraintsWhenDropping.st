constants
nameForPrimaryKeyConstraintsWhenDropping
	"Return the name we use to describe a constraint when dropping them. This is required because MySQL wants you to use 'DROP PRIMARY KEY' rather than the ANSI 'DROP CONSTRAINT'."
	^'CONSTRAINT'.