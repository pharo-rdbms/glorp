descriptors
descriptorForGlorpBook: aDescriptor

	| table |
	table := self tableNamed: 'BOOK'.
	aDescriptor table: table.
	aDescriptor addMapping: (	
		DirectMapping from: #id to: (table fieldNamed: 'ID')).
	aDescriptor addMapping: (	
		DirectMapping from: #title to: (table fieldNamed: 'TITLE')).
	aDescriptor addMapping: (	
		DirectMapping from: #copiesInStock to: (table fieldNamed: 'COPIES_IN_STOCK')).
	aDescriptor addMapping: (	
		DirectMapping from: #version to: (table fieldNamed: 'VERSION')).