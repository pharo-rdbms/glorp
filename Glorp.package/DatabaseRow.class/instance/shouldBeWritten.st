querying
shouldBeWritten
	table isNil ifTrue: [^shouldBeWritten].
	^shouldBeWritten and: [table shouldBeWritten].