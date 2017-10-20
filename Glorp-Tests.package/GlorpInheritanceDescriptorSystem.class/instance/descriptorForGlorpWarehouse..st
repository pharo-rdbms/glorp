descriptors/employees
descriptorForGlorpWarehouse: aDescriptor
	| table linkTable |
	table := self tableNamed: 'WAREHOUSE'.
	aDescriptor table: table.
	aDescriptor
		addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	aDescriptor
		addMapping:
			(DirectMapping from: #address to: (table fieldNamed: 'ADDRESS')).
	(aDescriptor newMapping: OneToOneMapping) 
		attributeName: #currentItem;
		join: (self polymorphicJoinToItemFromField: (table fieldNamed: 'CURRENT_ITEM_ID')).
		
	linkTable := self tableNamed: 'WAREHOUSE_ITEM_LINK'.
	(aDescriptor newMapping: ManyToManyMapping)
		attributeName: #items;
		join:
				(Join
						from: (table fieldNamed: 'ID')
						to: (linkTable fieldNamed: 'WAREHOUSE_ID'));
		reverseJoin: (self polymorphicJoinToItemFromField: (linkTable fieldNamed: 'ITEM_ID')).
	^aDescriptor.