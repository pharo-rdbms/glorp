accessing
linkTableJoin
	linkTableJoin isNil ifTrue: [^self join].
	^linkTableJoin