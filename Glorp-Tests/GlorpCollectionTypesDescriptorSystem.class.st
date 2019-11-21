Class {
	#name : #GlorpCollectionTypesDescriptorSystem,
	#superclass : #GlorpTestDescriptorSystem,
	#category : 'Glorp-Tests-CollectionTypeModels'
}

{ #category : #accessing }
GlorpCollectionTypesDescriptorSystem >> allTableNames [

	^#('GR_THINGWITHCOLLECTIONS' 'GR_THINGONE' 'GR_THING_LINK').
]

{ #category : #accessing }
GlorpCollectionTypesDescriptorSystem >> constructAllClasses [
	^super constructAllClasses add: GlorpThingWithLotsOfDifferentCollections; add: GlorpThingOne; yourself.
]

{ #category : #descriptors }
GlorpCollectionTypesDescriptorSystem >> descriptorForGlorpThingOne: aDescriptor [ 
	aDescriptor table: self thingOneTable.
	aDescriptor addMapping: (DirectMapping from: #id to: (self thingOneTable fieldNamed: 'ID')).
	aDescriptor addMapping: (DirectMapping from: #name to: (self thingOneTable fieldNamed: 'NAME')).
]

{ #category : #descriptors }
GlorpCollectionTypesDescriptorSystem >> descriptorForGlorpThingWithLotsOfDifferentCollections: aDescriptor [
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
]

{ #category : #tables }
GlorpCollectionTypesDescriptorSystem >> linkTable [
	^self tableNamed: 'GR_THING_LINK'.
]

{ #category : #tables }
GlorpCollectionTypesDescriptorSystem >> ownerTable [
	^self tableNamed: 'GR_THINGWITHCOLLECTIONS'.
]

{ #category : #tables }
GlorpCollectionTypesDescriptorSystem >> tableForGR_THINGONE: aTable [
	| setOwnerId arrayOwnerId |
	(aTable createFieldNamed: 'ID' type: platform serial) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 20).
	setOwnerId := aTable createFieldNamed: 'SET_OWNER' type: platform int4.
	aTable addForeignKeyFrom: setOwnerId
		to: (self ownerTable fieldNamed: 'ID').

	arrayOwnerId := aTable createFieldNamed: 'ARRAY_OWNER' type: platform int4.
	aTable addForeignKeyFrom: arrayOwnerId
		to: (self ownerTable fieldNamed: 'ID').
	aTable createFieldNamed: 'ARRAY_POSITION' type: platform int4.
]

{ #category : #tables }
GlorpCollectionTypesDescriptorSystem >> tableForGR_THINGWITHCOLLECTIONS: aTable [

	(aTable createFieldNamed: 'ID' type: platform serial) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 20).
]

{ #category : #tables }
GlorpCollectionTypesDescriptorSystem >> tableForGR_THING_LINK: aTable [
	| ownerId thingId |
	ownerId := (aTable createFieldNamed: 'OWNER_ID' type: platform int4) bePrimaryKey.
	aTable addForeignKeyFrom: ownerId to: (self ownerTable fieldNamed: 'ID').
	thingId := (aTable createFieldNamed: 'THING_ID' type: platform int4) bePrimaryKey.
	aTable
		addForeignKeyFrom: thingId
		to: (self thingOneTable fieldNamed: 'ID').
	aTable createFieldNamed: 'TYPE' type: (platform char: 1).
	aTable createFieldNamed: 'POSITION' type: platform int4.
]

{ #category : #tables }
GlorpCollectionTypesDescriptorSystem >> thingOneTable [
	^self tableNamed: 'GR_THINGONE'.
]
