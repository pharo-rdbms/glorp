descriptors/employees
descriptorForGlorpPerishableItem: aDescriptor

	| table |
	table := self tableNamed: 'PERISHABLE_ITEM'.
	aDescriptor table: table.
	aDescriptor addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	aDescriptor addMapping: (DirectMapping from: #name to: (table fieldNamed: 'NAME')).
	aDescriptor addMapping: (DirectMapping from: #age to: (table fieldNamed: 'AGE')).
	(self typeResolverFor: GlorpInventoryItem) register: aDescriptor.
	^aDescriptor