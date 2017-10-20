testing
hasEmptyWhereClause
	"If we have regular where clause entries, or if we have joins that aren't going to be printed in the tables portion, then we're not empty"
	whereClause willPrintAsWhereClause ifTrue: [^false].
	self useANSIJoins ifTrue: [^true].
	^joins isEmpty.