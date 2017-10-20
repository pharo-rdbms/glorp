descriptors
descriptorForGlorpTravelFile: aDescriptor
	| table |
	table := self tableNamed: 'FILES'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #name to: (table fieldNamed: 'name')