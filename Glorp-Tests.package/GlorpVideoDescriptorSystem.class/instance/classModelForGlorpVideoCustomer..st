class models
classModelForGlorpVideoCustomer: aClassModel
	aClassModel newAttributeNamed: #name type: String.
	aClassModel newAttributeNamed: #dateOfBirth type: Date.
	aClassModel newAttributeNamed: #onlinePurchases collectionOf: GlorpVideoPurchase.
	aClassModel newAttributeNamed: #inStorePurchases collectionOf: GlorpVideoPurchase.
	aClassModel newAttributeNamed: #inStoreRentals collectionOf: GlorpVideoRental.	
	aClassModel newAttributeNamed: #store type: GlorpVideoStore.
	aClassModel newAttributeNamed: #creditStatus type: GlorpVideoCreditStatus.