Class {
	#name : #GlorpCollectionTypesWithClassModelsDescriptorSystem,
	#superclass : #GlorpCollectionTypesDescriptorSystem,
	#category : 'Glorp-Tests-CollectionTypeModels'
}

{ #category : #'class models' }
GlorpCollectionTypesWithClassModelsDescriptorSystem >> classModelForGlorpThingWithLotsOfDifferentCollections: aClassModel [

	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name.
	aClassModel newAttributeNamed: #array collection: Array of: GlorpThingOne.
	aClassModel newAttributeNamed: #set collection: Set of: GlorpThingOne.
	aClassModel newAttributeNamed: #orderedCollection collection: OrderedCollection of: GlorpThingOne.
	aClassModel newAttributeNamed: #bag collection: Bag of: GlorpThingOne.
	aClassModel newAttributeNamed: #sortedCollection collection: SortedCollection of: GlorpThingOne.
]

{ #category : #descriptors }
GlorpCollectionTypesWithClassModelsDescriptorSystem >> descriptorForGlorpThingWithLotsOfDifferentCollections: aDescriptor [
	| ocMapping |
	aDescriptor table: self ownerTable.
	(aDescriptor newMapping: DirectMapping)
		from: #id to: (self ownerTable fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping)
		from: #name to: (self ownerTable fieldNamed: 'NAME').
	(aDescriptor newMapping: OneToManyMapping)
		attributeName: #array;
		orderBy: [:each | (each getTable: self thingOneTable) getField: 'ARRAY_POSITION'];
		writeTheOrderField;
			join:
				(Join
					from: (self ownerTable fieldNamed: 'ID')
					to: (self thingOneTable fieldNamed: 'ARRAY_OWNER')).
	(aDescriptor newMapping: OneToManyMapping)
		attributeName: #set;
		join:
			(Join
				from: (self ownerTable fieldNamed: 'ID')
				to: (self thingOneTable fieldNamed: 'SET_OWNER')).
	ocMapping := (aDescriptor newMapping: ManyToManyMapping)
		attributeName: #orderedCollection;
		join:
			(Join
				from: (self ownerTable fieldNamed: 'ID')
				to: (self linkTable fieldNamed: 'OWNER_ID')
				from: 'O'
				to: (self linkTable fieldNamed: 'TYPE')).
	ocMapping orderBy: [:each | (each getTable: self linkTable) getField: 'POSITION'].
	ocMapping writeTheOrderField.

	(aDescriptor newMapping: ManyToManyMapping)
		attributeName: #bag;
		join:
			(Join
				from: (self ownerTable fieldNamed: 'ID')
				to: (self linkTable fieldNamed: 'OWNER_ID')
				from: 'B'
				to: (self linkTable fieldNamed: 'TYPE')).
	(aDescriptor newMapping: ManyToManyMapping)
		attributeName: #sortedCollection;
		join:
			(Join
				from: (self ownerTable fieldNamed: 'ID')
				to: (self linkTable fieldNamed: 'OWNER_ID')
				from: 'S'
				to: (self linkTable fieldNamed: 'TYPE')).
]
