descriptors/tree nodes
descriptorForGlorpTreeNode: aDescriptor
	| table |
	table := self tableNamed: 'TREE_NODE'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping)
		from: #id
		to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: ToManyMapping)
		attributeName: #children;
		useLinkTable;
		join:
				(Join
						from: (table fieldNamed: 'ID')
						to: ((self tableNamed: 'TREE_NODE_LINK') fieldNamed: 'PARENT')).