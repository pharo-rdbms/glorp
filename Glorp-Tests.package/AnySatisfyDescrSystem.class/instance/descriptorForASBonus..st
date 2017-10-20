accessing
descriptorForASBonus: aDescriptor
	| table |
	table := self tableNamed: 'ASBONUS'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping)
		from: #id
		to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping)
		from: #name
		to: (table fieldNamed: 'NAME').
	(aDescriptor newMapping: DirectMapping)
		from: #credits
		to: (table fieldNamed: 'CREDITS').