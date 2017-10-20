descriptors
descriptorForGlorpVideoRental: aDescriptor

	| table |
	table := self tableNamed: 'VIDEO_RENTAL'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #title to: (table fieldNamed: 'TITLE').
	(aDescriptor newMapping: DirectMapping) from: #dueDate to: (table fieldNamed: 'DUE_DATE').
	(aDescriptor newMapping: DirectMapping) from: #price to: (table fieldNamed: 'PRICE').
	(aDescriptor newMapping: DirectMapping) fromPseudoVariable: #customerName to: (table fieldNamed: 'CUSTOMERNAME').

	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #customer.
	(aDescriptor newMapping: OneToOneMapping)
			attributeName: #store.