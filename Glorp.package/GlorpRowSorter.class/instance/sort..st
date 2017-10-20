sorting
sort: aCollection
	items := aCollection readStream.
	aCollection do: [:each | each status: #notVisited].
	[self hasSomethingToProcess] whileTrue: [self processCurrent].
	^sorted.