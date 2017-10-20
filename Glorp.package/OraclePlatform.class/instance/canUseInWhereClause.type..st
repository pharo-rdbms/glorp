testing
canUseInWhereClause: aValue type: aType
	"This is mostly for test support purposes. If we know we can't use a particular kind of value in the where clause on some database, don't try."

	(super canUseInWhereClause: aValue type: aType) ifFalse: [^false].
	"On Oracle we effectively can't compare constants against blobs."
	aType = self blob ifFalse: [^true].
	aValue isNil ifTrue: [^true].
	^false.