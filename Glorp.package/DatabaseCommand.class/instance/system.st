accessing
system
	self session isNil ifTrue: [^nil].
	^self session system.