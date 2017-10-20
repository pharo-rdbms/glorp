accessing
species

	self isInstantiated ifTrue: [^value species].
	query isNil ifTrue: [^Proxy].
	query resultClass isNil ifTrue: [^Proxy].
	^query resultClass species
