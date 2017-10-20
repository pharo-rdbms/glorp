sequences
newDatabaseIdentitySequenceNamed: aString
	"Return an identity sequence, with the given name. This method is useful for platforms
	which provide regular sequence objects as well as identity column objects. Glorp uses
	sequences when they are available, but pre-existing DB2 tables may contain identity
	columns, so we need to be able to recognize them."

	^self databaseIdentitySequenceClass named: aString