initializing
relatedTables
	| otherTables possibleLinkTables |
	otherTables := self basicReferenceDescriptor tables.
	usesLinkTable ifFalse: [^otherTables].

	linkFields isNil ifFalse: [^(linkFields collect: [:each | each table]) asSet asArray].
	possibleLinkTables := self system allTables
		select:
			[:each | 
			(each hasConstraintsToAnyOf: self descriptor tables)
				and: [each hasConstraintsToAnyOf: otherTables]].
	possibleLinkTables size ~= 1
		ifTrue: [CannotAutomaticallyDetermineJoin new
			tables: possibleLinkTables;
			signal: 'Cannot automatically determine link table..'].
	^possibleLinkTables.