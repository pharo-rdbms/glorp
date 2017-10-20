class models/airline
classModelForGlorpTravelAgency: aClassModel
	aClassModel newAttributeNamed: #name.
	aClassModel newAttributeNamed: #agents collectionOf: GlorpTravelAgent.