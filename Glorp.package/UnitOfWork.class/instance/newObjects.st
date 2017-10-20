accessing
newObjects
	newObjects isNil ifTrue: [newObjects := IdentitySet new].
	^newObjects