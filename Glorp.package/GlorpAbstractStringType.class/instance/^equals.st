comparing
= aType
	super = aType ifFalse: [^false].
	self width = aType width ifFalse: [^false].
	self queryType == self ifFalse: [
		self queryType = aType queryType ifFalse: [^false]].
	^true.