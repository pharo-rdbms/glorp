testing
canBind: aValue to: aType
	aValue isNil ifTrue: [^false].
	^super canBind: aValue to: aType.