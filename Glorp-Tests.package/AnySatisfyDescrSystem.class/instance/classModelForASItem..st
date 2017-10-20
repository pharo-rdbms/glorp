accessing
classModelForASItem: aClassModel
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name.
	aClassModel newAttributeNamed: #bonuses collectionOf: ASItemBonus.