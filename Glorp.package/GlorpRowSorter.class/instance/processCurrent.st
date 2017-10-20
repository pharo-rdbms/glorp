sorting
processCurrent
	self currentItemIsNew ifTrue: [^self initialVisit].
	self currentItemIsInProgress ifTrue: [^self secondVisit].
	self currentItemIsDone ifTrue: [^self].
	self error: 'Unknown item status'.