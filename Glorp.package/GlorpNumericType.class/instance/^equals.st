comparing
= aType

	"We do a special case check here that something that reads back as numeric with no scale/precision counts as being the same as an integer type"
	((aType class == self platform integer class) and: [self isIntegerType]) ifTrue: [^true].
	super = aType ifFalse: [^false].
	self precision = aType precision ifFalse: [^false].
	self scale = aType scale ifFalse: [^false].
	^true.