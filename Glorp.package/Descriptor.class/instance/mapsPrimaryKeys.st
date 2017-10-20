testing
mapsPrimaryKeys
	mapsPrimaryKeys isNil ifTrue: [mapsPrimaryKeys := self computeMapsPrimaryKeys].
	^mapsPrimaryKeys