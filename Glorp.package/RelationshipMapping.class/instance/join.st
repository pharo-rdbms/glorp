accessing
join
	join isNil ifTrue: [self initializeJoin].
	^join.