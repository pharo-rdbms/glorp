descriptors/employees
descriptorForGlorpNonperishableItem: aDescriptor

	| table |
	table := self tableNamed: 'NONPERISHABLE_ITEM'.
	aDescriptor table: table.
	aDescriptor addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	aDescriptor addMapping: (DirectMapping from: #name to: (table fieldNamed: 'NAME')).
	aDescriptor addMapping: (DirectMapping from: #serialNumber to: (table fieldNamed: 'SERIAL_NUMBER')).
	(self typeResolverFor: GlorpInventoryItem) register: aDescriptor.
	^aDescriptor