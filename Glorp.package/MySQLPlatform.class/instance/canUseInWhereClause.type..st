testing
canUseInWhereClause: aValue type: aType
	"This is mostly for test support purposes. If we know we can't use a particular kind of value in the where clause on some database, don't try."

	(super canUseInWhereClause: aValue type: aType) ifFalse: [^false].
	"On MySQL we don't seem to be able to compare constants against blobs."
	aType = self blob ifTrue: [^false].
	^true.