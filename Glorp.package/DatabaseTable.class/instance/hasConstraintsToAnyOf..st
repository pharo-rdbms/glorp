testing
hasConstraintsToAnyOf: aCollectionOfTables
	aCollectionOfTables do: [:each |
		(self hasConstraintsTo: each) ifTrue: [^true]].
	^false.