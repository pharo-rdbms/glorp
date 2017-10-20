Tests
testToManyRelation
	| bankTransTable customerTable ownerId btOwnerId mapping customerModel customerDescriptor |
	bankTransTable := system addEmptyTableNamed: 'BANK_TRANS'.
	customerTable := system addEmptyTableNamed: 'GR_CUSTOMER'.
	ownerId := customerTable createFieldNamed: 'ID' type: platform int4.
	btOwnerId := bankTransTable createFieldNamed: 'OWNER_ID'
				type: platform int4.
	bankTransTable addForeignKeyFrom: btOwnerId to: ownerId.
	customerModel := system addClassModelFor: GlorpCustomer.
	customerModel newAttributeNamed: #transactions
		collectionOf: GlorpBankTransaction.
	system addClassModelFor: GlorpBankTransaction.
	system addEmptyDescriptorFor: GlorpBankTransaction.
	customerDescriptor := system addEmptyDescriptorFor: GlorpCustomer.
	customerDescriptor table: customerTable.
	system createMappingIn: customerDescriptor
		fromClassModelForAttributeNamed: #transactions.
	mapping := customerDescriptor mappingForAttributeNamed: #transactions.
	self assert: mapping class = ToManyMapping.
	self assert: mapping referenceClass = GlorpBankTransaction