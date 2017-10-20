comparing
= aType
	super = aType ifFalse: [^false].
	self queryType == self ifTrue: [^true].
	self queryType = aType queryType
		 ifFalse: [^false].
	^true.