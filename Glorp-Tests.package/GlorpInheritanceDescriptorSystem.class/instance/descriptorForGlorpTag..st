as yet unclassified
descriptorForGlorpTag: aDescriptor 
	| table |
	table := self tableNamed: 'GLORP_TAG'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping)
		from: #id
		to: (table fieldNamed: 'id').
	(aDescriptor newMapping: DirectMapping)
		from: #key
		to: (table fieldNamed: 'key').
	(aDescriptor newMapping: DirectMapping)
		from: #label
		to: (table fieldNamed: 'label').