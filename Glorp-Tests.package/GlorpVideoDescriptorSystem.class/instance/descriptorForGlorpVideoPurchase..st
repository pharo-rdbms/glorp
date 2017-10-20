descriptors
descriptorForGlorpVideoPurchase: aDescriptor

	| table |
	table := self tableNamed: 'VIDEO_PURCHASE'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #title to: (table fieldNamed: 'TITLE').
	(aDescriptor newMapping: DirectMapping) from: #price to: (table fieldNamed: 'PRICE').
	(aDescriptor newMapping: DirectMapping) from: #inStore to: (table fieldNamed: 'IN_STORE').

	(aDescriptor newMapping: OneToOneMapping)
			useLinkTable;
			attributeName: #store;
			constructRowMapKeyAs: [:purchase :store | 
					MultipleRowMapKey with: purchase with: store with: purchase customer yourself].

	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #customer.