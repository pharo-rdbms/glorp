mapping
typeMappingRoot
	^self isTypeMappingRoot 
		ifTrue: [self mappedClass]
		ifFalse: [self descriptorForSuperclass typeMapping typeMappingRoot]