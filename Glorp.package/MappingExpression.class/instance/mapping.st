internal
mapping
	mapping isNil ifTrue: [
		| descriptor |
		descriptor := self sourceDescriptor.
		descriptor isNil ifTrue: [^nil].
		mapping := descriptor mappingForAttributeNamed: name].
	^mapping.