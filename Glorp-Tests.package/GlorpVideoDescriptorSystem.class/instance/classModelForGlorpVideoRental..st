class models
classModelForGlorpVideoRental: aClassModel
	aClassModel newAttributeNamed: #id type: Integer.
	aClassModel newAttributeNamed: #title type: String.
	aClassModel newAttributeNamed: #price type: Number.
	aClassModel newAttributeNamed: #dueDate type: Date.
	aClassModel newAttributeNamed: #customer type: GlorpVideoCustomer.
	aClassModel newAttributeNamed: #store type: GlorpVideoStore.