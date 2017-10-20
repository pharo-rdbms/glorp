accessing
descriptorForASItem: aDescriptor
	| table |
	table := self tableNamed: 'ASITEM'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping)
		from: #id
		to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping)
		from: #name
		to: (table fieldNamed: 'NAME').
	(aDescriptor newMapping: OneToManyMapping)
		attributeName: #bonuses.