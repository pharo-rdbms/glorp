class models
classModelForGlorpVideoStore: aClassModel
	aClassModel newAttributeNamed: #name type: String.
	aClassModel newAttributeNamed: #purchases collectionOf: GlorpVideoPurchase.
	aClassModel newAttributeNamed: #customers collectionOf: GlorpVideoCustomer.