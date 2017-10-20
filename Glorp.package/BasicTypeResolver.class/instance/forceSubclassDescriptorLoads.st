private
forceSubclassDescriptorLoads
	self rootClass allSubclassesDo: [ :each | self system descriptorFor: each ].
	subclassDescriptorsBuilt := true