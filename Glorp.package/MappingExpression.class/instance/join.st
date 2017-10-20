accessing
join
	self mapping isNil ifTrue: [^nil].
	^self mapping join.