descriptors
descriptorForGlorpThingWithLotsOfDifferentCollections: aDescriptor
	| ocMapping |
	aDescriptor table: self ownerTable.
	aDescriptor
		addMapping:
			(DirectMapping from: #id to: (self ownerTable fieldNamed: 'ID')).
	aDescriptor
		addMapping:
			(DirectMapping from: #name to: (self ownerTable fieldNamed: 'NAME')).
	aDescriptor
		addMapping:
			((OneToManyMapping new)
				attributeName: #array;
				referenceClass: GlorpThingOne;
				collectionType: Array;
				orderBy: [:each | (each getTable: self thingOneTable) getField: 'ARRAY_POSITION'];
				writeTheOrderField;
				join:
						(Join
								from: (self ownerTable fieldNamed: 'ID')
								to: (self thingOneTable fieldNamed: 'ARRAY_OWNER'))).
	aDescriptor
		addMapping:
			((OneToManyMapping new)
				attributeName: #set;
				referenceClass: GlorpThingOne;
				collectionType: Set;
				join:
						(Join
								from: (self ownerTable fieldNamed: 'ID')
								to: (self thingOneTable fieldNamed: 'SET_OWNER'))).
	ocMapping := ((ManyToManyMapping new)
				attributeName: #orderedCollection;
				referenceClass: GlorpThingOne;
				collectionType: OrderedCollection;
				join:
						(Join
								from: (self ownerTable fieldNamed: 'ID')
								to: (self linkTable fieldNamed: 'OWNER_ID')
								from: 'O'
								to: (self linkTable fieldNamed: 'TYPE'))).
	ocMapping orderBy: [:each | (each getTable: self linkTable) getField: 'POSITION'].
	ocMapping writeTheOrderField.
	aDescriptor addMapping: ocMapping.

	aDescriptor
		addMapping:
			((ManyToManyMapping new)
				attributeName: #bag;
				referenceClass: GlorpThingOne;
				collectionType: Bag;
				join:
						(Join
								from: (self ownerTable fieldNamed: 'ID')
								to: (self linkTable fieldNamed: 'OWNER_ID')
								from: 'B'
								to: (self linkTable fieldNamed: 'TYPE'))).
	aDescriptor
		addMapping:
			((ManyToManyMapping new)
				attributeName: #sortedCollection;
				referenceClass: GlorpThingOne;
				collectionType: SortedCollection;
				join:
						(Join
								from: (self ownerTable fieldNamed: 'ID')
								to: (self linkTable fieldNamed: 'OWNER_ID')
								from: 'S'
								to: (self linkTable fieldNamed: 'TYPE'))).