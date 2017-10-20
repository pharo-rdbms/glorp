descriptors/employees
descriptorForGlorpInventoryItem: aDescriptor

	(self typeResolverFor: GlorpInventoryItem) register: aDescriptor abstract: true.
	^aDescriptor