Tests
testAllAttributesSkipDefined
	| bankTransTable customerTable ownerId btOwnerId customerModel customerDescriptor ownerId2 |
	bankTransTable := system addEmptyTableNamed: 'BANK_TRANS'.
	customerTable := system addEmptyTableNamed: 'GR_CUSTOMER'.
	ownerId := customerTable createFieldNamed: 'ID' type: platform int4.
	ownerId2 := customerTable createFieldNamed: 'ID2' type: platform int4.
	btOwnerId := bankTransTable createFieldNamed: 'OWNER_ID'
				type: platform int4.
	bankTransTable addForeignKeyFrom: btOwnerId to: ownerId.
	customerModel := system addClassModelFor: GlorpCustomer.
	customerModel newAttributeNamed: #id type: Integer.
	customerModel newAttributeNamed: #transactions
		collectionOf: GlorpBankTransaction.
	system addClassModelFor: GlorpBankTransaction.
	system addEmptyDescriptorFor: GlorpBankTransaction.
	customerDescriptor := system addEmptyDescriptorFor: GlorpCustomer.
	customerDescriptor table: customerTable.
	(customerDescriptor newMapping: DirectMapping) from: #id to: ownerId2.
	system createMappingsFromClassModelIn: customerDescriptor.
	self assert: customerDescriptor mappings size = 2.
	self 
		assert: (customerDescriptor mappingForAttributeNamed: #id) field = ownerId2