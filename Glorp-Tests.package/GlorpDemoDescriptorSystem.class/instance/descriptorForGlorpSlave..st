owner
descriptorForGlorpSlave: aDescriptor
	| table |
	table := self tableNamed: 'GLORP_SLAVE'.
	aDescriptor table: table.
	aDescriptor
		addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).