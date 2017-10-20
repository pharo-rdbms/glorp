accessing
mappingFromMeOrSubclasses
	"Return the mapping for me, but if the field is not mapped here, and the class uses inheritance, check for subclasses, and use a random one of the subclass mappings."

	| subclassDescriptors |
	self mapping isNil ifFalse: [^self mapping].
	self sourceDescriptor isNil ifTrue: [^self mapping].
	subclassDescriptors := (self sourceDescriptor typeResolver descriptorsRequiringIndependentQueriesFor: self sourceDescriptor describedClass).
	subclassDescriptors do: [:each | 
		| subMapping |
		subMapping := each mappingForAttributeNamed: name.
		subMapping isNil ifFalse: [^subMapping]].
	"If subclasses didn't work, just fall through to the normal error processing."
	^self mapping.