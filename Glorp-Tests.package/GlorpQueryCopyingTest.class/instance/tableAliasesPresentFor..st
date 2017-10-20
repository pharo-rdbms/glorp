As yet unclassified
tableAliasesPresentFor: aQuery
	aQuery whereClause detect: [:each | each hasTableAliases] ifNone: [^false].
	^true.