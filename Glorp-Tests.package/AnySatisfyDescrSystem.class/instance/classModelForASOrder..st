accessing
classModelForASOrder: aClassModel
	aClassModel newAttributeNamed: #orderNo.
	aClassModel newAttributeNamed: #customer type: ASCustomer.
	aClassModel newAttributeNamed: #lineItems collectionOf: ASOrderLineItem.