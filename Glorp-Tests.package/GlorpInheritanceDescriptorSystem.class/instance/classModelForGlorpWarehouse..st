descriptors/employees
classModelForGlorpWarehouse: aClassModel
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #address.
	aClassModel newAttributeNamed: #currentItem type: GlorpInventoryItem.
	aClassModel newAttributeNamed: #items collectionOf: GlorpInventoryItem.