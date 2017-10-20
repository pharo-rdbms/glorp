caching
lookupRootClassFor: aClass
	| descriptor |
	descriptor := self system descriptorFor: aClass.
	^descriptor notNil
			ifTrue: [ descriptor typeMappingRootDescriptor describedClass ]
			ifFalse: [ aClass ]