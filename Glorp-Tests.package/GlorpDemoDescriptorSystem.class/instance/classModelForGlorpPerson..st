descriptors/bank
classModelForGlorpPerson: aClassModel
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name.
	aClassModel newAttributeNamed: #address type: GlorpAddress.
	aClassModel newAttributeNamed: #emailAddresses collectionOf: GlorpEmailAddress.