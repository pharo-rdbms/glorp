As yet unclassified
platform
	self session isNil ifTrue: [^nil].
	^self session platform.