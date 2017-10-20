accessing
classModelForASOrderLineItem: aClassModel
	aClassModel newAttributeNamed: #posNo.
	aClassModel newAttributeNamed: #item type: ASItem.
	aClassModel newAttributeNamed: #order type: ASOrder.
	aClassModel newAttributeNamed: #quantity.
	aClassModel newAttributeNamed: #price.