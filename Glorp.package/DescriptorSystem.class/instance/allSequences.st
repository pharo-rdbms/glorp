accessing
allSequences
	sequences isEmpty ifFalse: [^sequences].
	sequences := self allSequencesFor: self allTables.
	^sequences.