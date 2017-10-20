fields
aliasedTableFor: aDatabaseTable  ifAbsent: aBlock
	tableAliases isNil ifTrue: [^aBlock value].
	aDatabaseTable isAliased ifTrue: [^aDatabaseTable].
	^tableAliases at: aDatabaseTable ifAbsent: [aBlock value].