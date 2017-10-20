api
createMappingsFromClassModelIn: aDescriptor 
	aDescriptor classModel attributesDo: 
			[:each | 
			(aDescriptor mappingForAttributeNamed: each name) isNil 
				ifTrue: 
					[self createMappingIn: aDescriptor
						fromClassModelForAttributeNamed: each name]]