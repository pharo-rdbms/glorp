private
createMappingIn: aDescriptor fromClassModelForAttributeNamed: aSymbol 
	| attribute referenceModel |
	attribute := aDescriptor classModel attributeNamed: aSymbol.
	referenceModel := self classModelFor: attribute type.
	referenceModel isNil 
		ifTrue: 
			[^(aDescriptor newMapping: DirectMapping) from: aSymbol
				to: (aDescriptor table 
						fieldNamed: (self fieldNameForAttributeName: aSymbol))]
		ifFalse: 
			[attribute isCollectionAttribute 
				ifTrue: [^(aDescriptor newMapping: ToManyMapping) attributeName: aSymbol]
				ifFalse: [^(aDescriptor newMapping: OneToOneMapping) attributeName: aSymbol]]