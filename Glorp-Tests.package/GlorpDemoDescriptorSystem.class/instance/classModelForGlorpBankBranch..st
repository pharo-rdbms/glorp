descriptors/bank
classModelForGlorpBankBranch: aClassModel
	aClassModel newAttributeNamed: #branchNumber.
	aClassModel newAttributeNamed: #accounts collectionOf: GlorpBankAccount.