owner
descriptorForGlorpOwner: aDescriptor
	| table slaveTable |
	table := self tableNamed: 'GLORP_OWNER'.
	slaveTable := self tableNamed: 'GLORP_SLAVE'.
	aDescriptor table: table.
	aDescriptor
		addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID'));
		addMapping:
				((OneToManyMapping new)
						attributeName: #slaves;
						referenceClass: GlorpSlave;
						collectionType: OrderedCollection;
						orderBy:
								[:each | (each getTable: 'GLORP_SLAVE') getField: 'POSITION_IN_OWNER'];
						writeTheOrderField;
						mappingCriteria:
								(Join
										from: (table fieldNamed: 'ID')
										to: (slaveTable fieldNamed: 'OWNER_ID')));
		addMapping:
				((OneToOneMapping new)
						attributeName: #slave;
						referenceClass: GlorpSlave;
						mappingCriteria:
								(Join
										from: (table fieldNamed: 'SLAVE_ID')
										to: (slaveTable fieldNamed: 'ID'))).