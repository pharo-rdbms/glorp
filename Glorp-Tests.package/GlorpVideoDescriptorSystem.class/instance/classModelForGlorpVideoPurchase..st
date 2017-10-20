class models
classModelForGlorpVideoPurchase: aClassModel
	aClassModel newAttributeNamed: #id type: Integer.
	aClassModel newAttributeNamed: #title type: String.
	aClassModel newAttributeNamed: #price type: Number.
	aClassModel newAttributeNamed: #inStore type: Boolean.
	aClassModel newAttributeNamed: #customer type: GlorpVideoCustomer.	
	aClassModel newAttributeNamed: #store type: GlorpVideoStore.