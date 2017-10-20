descriptors
descriptorForGlorpVideoCreditStatus: aDescriptor

	| table |
	table := self tableNamed: 'VIDEO_CREDIT_STATUS'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #balanceOwing to: (table fieldNamed: 'BALANCE').
	(aDescriptor newMapping: DirectMapping) from: #dateOwing to: (table fieldNamed: 'DATE_OWING').
	(aDescriptor newMapping: DirectMapping) from: #comments to: (table fieldNamed: 'COMMENTS').

	(aDescriptor newMapping: OneToOneMapping)
			attributeName: #customer.