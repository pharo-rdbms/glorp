accessing
hasField

	self mapping isNil ifTrue: [^false].
"If we have a descriptor, then either we're a mapping to a full object, in which case we can't answer this properly, or we're a direct to-many mapping, in which case we can."
	self hasDescriptor ifTrue: [
		^self mapping mapsSimpleObject].
	^true.