class models/airline
classModelForGlorpReservation: aClassModel
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #passengers collectionOf: GlorpPassenger.
	aClassModel newAttributeNamed: #passenger type: GlorpPassenger.