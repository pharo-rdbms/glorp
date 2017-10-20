classes
classModelForGlorpTravelFolder: aClassModel
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name.
	aClassModel newAttributeNamed: #files collectionOf: GlorpTravelFile.
	aClassModel newAttributeNamed: #unordered collectionOf: GlorpTravelFile.