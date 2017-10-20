sequences
newDatabaseSequenceNamed: aString
	"Return a sequence of the type we use, with the given name"
	^self databaseSequenceClass named: aString.