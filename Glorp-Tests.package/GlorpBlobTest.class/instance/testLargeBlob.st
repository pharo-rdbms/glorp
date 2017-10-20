tests
testLargeBlob
	| blob |
	self platform isSQLite3Platform ifTrue: [ ^ self skip. ].
	self platform isUDBCSQLite3Platform ifTrue: [ ^ self skip. ].
	blob := self mediumlargeBlob.
	(session platform useBinding not and: [blob size > session platform maximumQueryValueSize])
		ifTrue: [Transcript cr; show: '******* Skipping large unbound blob test']
		ifFalse: [self helpTestValue: blob].
	blob := self largeBlob.
	(session platform useBinding not and: [blob size > session platform maximumQueryValueSize])
		ifFalse: [self helpTestValue: blob]