descriptors
classModelForGlorpPublisher: aClassModel 
 
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name. 
	aClassModel newAttributeNamed: #titles collection: Array of: String.
	aClassModel newAttributeNamed: #titlesWithNumberInStock dictionaryFrom: String to: Integer.
	aClassModel newAttributeNamed: #employees dictionaryFrom: String to: GlorpPublisherEmployee.
	aClassModel newAttributeNamed: #differentBunchOfEmployeesById dictionaryFrom: Integer to: GlorpPublisherEmployee.

"	aClassModel newAttributeNamed: #titlesWithNumberInStockLink collection: Dictionary of: Integer."