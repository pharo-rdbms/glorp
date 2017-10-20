accessing
allTables
	tables isEmpty ifTrue: [self constructAllTables].
	^tables.