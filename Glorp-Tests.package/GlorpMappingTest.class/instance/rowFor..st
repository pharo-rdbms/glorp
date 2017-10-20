support
rowFor: anObject
	| descriptor |
	descriptor := system descriptorFor: anObject.
	descriptor isNil ifTrue: [^nil].

	^rowMap rowForTable: descriptor table withKey: anObject.