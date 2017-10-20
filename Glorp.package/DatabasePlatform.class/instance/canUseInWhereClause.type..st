testing
canUseInWhereClause: aValue type: aType
	(Dialect isFloatingPoint: aValue) ifTrue: [^false].
	^true.