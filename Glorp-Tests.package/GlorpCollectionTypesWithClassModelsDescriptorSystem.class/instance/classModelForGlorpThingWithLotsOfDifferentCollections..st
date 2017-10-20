class models
classModelForGlorpThingWithLotsOfDifferentCollections: aClassModel

	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name.
	aClassModel newAttributeNamed: #array collection: Array of: GlorpThingOne.
	aClassModel newAttributeNamed: #set collection: Set of: GlorpThingOne.
	aClassModel newAttributeNamed: #orderedCollection collection: OrderedCollection of: GlorpThingOne.
	aClassModel newAttributeNamed: #bag collection: Bag of: GlorpThingOne.
	aClassModel newAttributeNamed: #sortedCollection collection: SortedCollection of: GlorpThingOne.