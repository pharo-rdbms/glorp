descriptors/other
descriptorForDefaultableThing: aDescriptor
	| table |
	table := self tableNamed: 'DEFAULTABLE_THING'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping)
		from: #id
		to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping)
		from: #boolean
		to: (table fieldNamed: 'MY_BOOL').
	(aDescriptor newMapping: DirectMapping)
		from: #integer
		to: (table fieldNamed: 'MY_INT').