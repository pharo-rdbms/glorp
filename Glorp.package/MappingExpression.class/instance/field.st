accessing
field

	self mapping isNil ifTrue: [self error: '"', name, '" is not a mapped property name in ', base descriptor describedClass name].
	self hasDescriptor ifTrue: [
		"If we have a descriptor, then either we're a mapping to a full object, in which case we can't answer this properly, or we're a direct to-many mapping, in which case we can."
		self mapping mapsSimpleObject
			ifTrue: [^self translateField: self mapping field]
			ifFalse: [self error: '"',name, 
				'" is not an attribute that resolves to a field in the mapped tables for ', 
					base descriptor describedClass name]].
	^base translateField: self mapping field.