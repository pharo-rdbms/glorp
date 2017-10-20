class models
classModelForGlorpVideoCreditStatus: aClassModel
	aClassModel newAttributeNamed: #customer type: GlorpVideoCustomer.
	aClassModel newAttributeNamed: #store type: GlorpVideoStore.
	aClassModel newAttributeNamed: #balanceOwing type: Number.
	aClassModel newAttributeNamed: #dateOwing type: Date.
	aClassModel newAttributeNamed: #comments type: String.