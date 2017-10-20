mapping
reverseMapping
	^self class new
		attributeName: #temporaryReverseMappingForEmbeddedMapping;
		referenceClass: self descriptor describedClass;
		descriptor: self descriptor.