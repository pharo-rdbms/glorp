descriptors/bank
classModelForGlorpCustomer: aClassModel
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name.
	aClassModel newAttributeNamed: #transactions collectionOf: GlorpBankTransaction.
	"Note: accounts is a 1-1 in this model"
	aClassModel newAttributeNamed: #accounts type: GlorpBankAccount.
	aClassModel newAttributeNamed: #accountsSortedById collectionOf: GlorpBankAccount.
	aClassModel newAttributeNamed: #accountsSortedByIdDescending collectionOf: GlorpBankAccount.