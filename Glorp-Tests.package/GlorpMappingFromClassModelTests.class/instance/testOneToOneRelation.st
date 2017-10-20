Tests
testOneToOneRelation
	| bankTransTable customerTable ownerId btOwnerId bankTransModel descriptor mapping |
	bankTransTable := system addEmptyTableNamed: 'BANK_TRANS'.
	customerTable := system addEmptyTableNamed: 'GR_CUSTOMER'.
	ownerId := customerTable createFieldNamed: 'ID' type: platform int4.
	btOwnerId := bankTransTable createFieldNamed: 'OWNER_ID'
				type: platform int4.
	bankTransTable addForeignKeyFrom: btOwnerId to: ownerId.
	system
		addClassModelFor: GlorpCustomer;
		addEmptyDescriptorFor: GlorpCustomer.
	bankTransModel := system addClassModelFor: GlorpBankTransaction.
	bankTransModel newAttributeNamed: #owner type: GlorpCustomer.
	descriptor := system addEmptyDescriptorFor: GlorpBankTransaction.
	descriptor table: bankTransTable.
	system createMappingIn: descriptor fromClassModelForAttributeNamed: #owner.
	mapping := descriptor mappingForAttributeNamed: #owner.
	self assert: mapping class = OneToOneMapping