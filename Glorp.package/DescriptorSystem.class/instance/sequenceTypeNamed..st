api
sequenceTypeNamed: aString
	"Return a sequence type whose sequence has the given name."
	^self platform sequence sequence: (self databaseSequenceNamed: aString)