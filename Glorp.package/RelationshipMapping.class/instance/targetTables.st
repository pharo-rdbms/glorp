validation
targetTables
	^((self usesLinkTable ifTrue: [self reverseJoin] ifFalse: [self join]) allTargetFields collect: [:each | each table]) asSet.