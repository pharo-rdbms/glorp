initialization
constructClassesFromDescriptorMethods
	self withAllSuperclassesDo: [:aClass | self addClassesFromDescriptorMethodsFor: aClass].

	self class includeAllClassesWithDescriptorMethods
		ifTrue:
			[Object withAllSubclasses
				do:
					[:each | 
					(each class
						compiledMethodAt: #glorpSetupDescriptor:forSystem:
						ifAbsent: [nil]) isNil ifFalse: [allClasses add: each]]].