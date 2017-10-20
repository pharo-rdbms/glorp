accessing
classModelForASCustomer: aClassModel
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name.
	aClassModel newAttributeNamed: #orders collectionOf: ASOrder.