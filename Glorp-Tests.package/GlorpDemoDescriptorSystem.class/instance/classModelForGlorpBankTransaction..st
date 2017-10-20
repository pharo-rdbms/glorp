descriptors/bank
classModelForGlorpBankTransaction: aClassModel
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #owner type: GlorpCustomer.
	aClassModel newAttributeNamed: #amount type: GlorpMoney.
	aClassModel newAttributeNamed: #serviceCharge type: GlorpServiceCharge.