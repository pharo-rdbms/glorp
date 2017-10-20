descriptors
classModelForGlorpTinyPublisher: aClassModel 
 
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name. 
	aClassModel newAttributeNamed: #titles collection: Array of: String.
	aClassModel newAttributeNamed: #titlesWithNumberInStock dictionaryFrom: String to: Integer.