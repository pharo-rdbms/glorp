testing
canUseInWhereClause: aValue type: aType
	"SQLite3 requires blobs to be encoded when part of a WHERE clause.
	Glorp currently doesn't handle this, so tag blobs as not usable in a WHERE clause."

	aType = self blob ifTrue: [ ^false ].
	^super canUseInWhereClause: aValue type: aType.