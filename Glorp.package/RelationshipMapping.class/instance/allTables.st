accessing
allTables

	(self join) isNil ifTrue: [^#()].
	^(self join) allTables.