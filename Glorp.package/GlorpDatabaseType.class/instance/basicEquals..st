comparing
basicEquals: aType
	self class == aType class ifFalse: [^false].
	self platform == aType platform ifFalse: [^false].
	self typeString = aType typeString ifFalse: [^false].
	^true.