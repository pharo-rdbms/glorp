testing
canBind: aValue to: aType
	useBinding ifFalse: [^false].
	^self platform canBind: aValue to: aType underlyingType.