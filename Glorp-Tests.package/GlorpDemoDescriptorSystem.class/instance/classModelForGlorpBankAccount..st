descriptors/bank
classModelForGlorpBankAccount: aClassModel
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #accountNumber type: GlorpBankAccountNumber.
	aClassModel newAttributeNamed: #accountHolders collectionOf: GlorpCustomer.