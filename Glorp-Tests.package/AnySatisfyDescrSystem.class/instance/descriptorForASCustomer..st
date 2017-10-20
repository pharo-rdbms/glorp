accessing
descriptorForASCustomer: aDescriptor
	| table |
	table := self tableNamed: 'ASCUSTOMER'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping)
		from: #id
		to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping)
		from: #name
		to: (table fieldNamed: 'NAME').
	(aDescriptor newMapping: OneToManyMapping)
		attributeName: #orders.