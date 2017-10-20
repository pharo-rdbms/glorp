descriptors/bank
classModelForGlorpCustomer: aClassModel
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name.
	aClassModel newAttributeNamed: #transactions collectionOf: GlorpBankTransaction.
	aClassModel newAttributeNamed: #accounts collectionOf: GlorpBankAccount.
	aClassModel newAttributeNamed: #accountsSortedById collectionOf: GlorpBankAccount.
	aClassModel newAttributeNamed: #accountsSortedByIdDescending collectionOf: GlorpBankAccount.