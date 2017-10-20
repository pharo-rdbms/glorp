comparing
= aJoin
	aJoin class == self class ifFalse: [^false].
	aJoin allSourceFields = sources ifFalse: [^false].
	aJoin allTargetFields = targets ifFalse: [^false].
	^true.