accessing
system
	self descriptor isNil ifTrue: [^nil].
	^self descriptor system.