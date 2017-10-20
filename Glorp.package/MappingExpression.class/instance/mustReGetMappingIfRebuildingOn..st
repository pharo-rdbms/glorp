preparing
mustReGetMappingIfRebuildingOn: newBase
	"Return true if we need to do a full get: when rebuilding, rather than being able to preserve the mapping that we had before."

	"If we didn't have a mapping yet, then just do a get"
	mapping isNil ifTrue: [^true].
	"If this is a phantom mapping, we must not try to re-get it."
	self phantom ifTrue: [^false].
	"Otherwise, we're a normal mapping, and we don't need to re-get the mapping unless the class is different, probably because of inheritance. But note that in some cases we may not know our descriptor yet."
	self base hasDescriptor ifFalse: [^false].
	self base descriptor isNil ifTrue: [^false].
	^self base descriptor ~= newBase descriptor.