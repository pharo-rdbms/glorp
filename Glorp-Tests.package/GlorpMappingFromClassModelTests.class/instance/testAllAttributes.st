Tests
testAllAttributes
	| bankTransTable customerTable ownerId btOwnerId customerModel customerDescriptor attributes |
	bankTransTable := system addEmptyTableNamed: 'BANK_TRANS'.
	customerTable := system addEmptyTableNamed: 'GR_CUSTOMER'.
	ownerId := customerTable createFieldNamed: 'ID' type: platform int4.
	btOwnerId := bankTransTable createFieldNamed: 'OWNER_ID'
				type: platform int4.
	bankTransTable addForeignKeyFrom: btOwnerId to: ownerId.
	customerModel := system addClassModelFor: GlorpCustomer.
	customerModel newAttributeNamed: #id type: Integer.
	customerModel newAttributeNamed: #transactions
		collectionOf: GlorpBankTransaction.
	system addClassModelFor: GlorpBankTransaction.
	system addEmptyDescriptorFor: GlorpBankTransaction.
	(system descriptorFor: GlorpBankTransaction) table: (system tableNamed: 'BANK_TRANS').
	customerDescriptor := system addEmptyDescriptorFor: GlorpCustomer.
	customerDescriptor table: customerTable.
	system createMappingsFromClassModelIn: customerDescriptor.
	self assert: (customerDescriptor mappingForAttributeNamed: #id) notNil.
	self 
		assert: (customerDescriptor mappingForAttributeNamed: #transactions) notNil.
	system validate.
	attributes := OrderedCollection new.
	customerDescriptor classModel attributesDo: [:each | attributes add: each].
	self assert: attributes size = 2.