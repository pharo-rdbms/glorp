descriptors/employees
descriptorForGlorpUnassembledItem: aDescriptor

	| table |
	table := self tableNamed: 'UNASSEMBLED_ITEM'.
	aDescriptor table: table.
	aDescriptor addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	aDescriptor addMapping: (DirectMapping from: #name to: (table fieldNamed: 'NAME')).
	aDescriptor addMapping: (DirectMapping from: #serialNumber to: (table fieldNamed: 'SERIAL_NUMBER')).
	aDescriptor addMapping: (DirectMapping from: #assemblyCost to: (table fieldNamed: 'ASSEM_COST')).
	(self typeResolverFor: GlorpInventoryItem) register: aDescriptor.
	^aDescriptor