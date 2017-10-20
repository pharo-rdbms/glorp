private/mapping
addToCommitPlan: aRow
	aRow shouldBeWritten ifFalse: [^self].
	commitPlan add: aRow