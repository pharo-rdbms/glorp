accessing
cachePolicy
	cachePolicy isNil ifTrue: [^system cachePolicy].
	^cachePolicy