Class {
	#name : #GlorpMappingFromClassModelTests,
	#superclass : #GlorpTestCase,
	#instVars : [
		'system',
		'platform'
	],
	#category : #'Glorp-Unit-Tests-Tests'
}

{ #category : #running }
GlorpMappingFromClassModelTests >> setUp [
	platform := PostgreSQLPlatform new.
	system := DynamicDescriptorSystem forPlatform: platform
]

{ #category : #Tests }
GlorpMappingFromClassModelTests >> someCode [
	| model descriptor mapping table |
	table := DatabaseTable named: 'TYPETESTS'.
	table createFieldNamed: 'test' type: system platform boolean.
	model := system addClassModelFor: GlorpTypeTestsModelClass.
	model newAttributeNamed: #test type: Boolean.
	system privateTableAt: table name put: table.
	descriptor := Descriptor new.
	descriptor system: system.
	descriptor classModel: model.
	descriptor table: table.
	descriptor 
		addMapping: (DirectMapping from: #id to: (table fieldNamed: 'id')).
	Boolean isNil 
		ifTrue: [mapping := DirectMapping from: #test to: (table fieldNamed: 'test')]
		ifFalse: 
			[mapping := DirectMapping 
						from: #test
						type: Boolean
						to: (table fieldNamed: 'test')].
	descriptor addMapping: mapping.
	system privateDescriptorAt: GlorpTypeTestsModelClass put: descriptor.
	^system
]

{ #category : #Tests }
GlorpMappingFromClassModelTests >> testAllAttributes [
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
]

{ #category : #Tests }
GlorpMappingFromClassModelTests >> testAllAttributesSkipDefined [
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
]

{ #category : #Tests }
GlorpMappingFromClassModelTests >> testDirectMapping [
	| customerTable ownerId descriptor mapping customerModel |
	customerTable := system addEmptyTableNamed: 'GR_CUSTOMER'.
	ownerId := customerTable createFieldNamed: 'ID' type: platform int4.
	customerModel := system addClassModelFor: GlorpCustomer.
	customerModel newAttributeNamed: #id type: Integer.
	descriptor := system addEmptyDescriptorFor: GlorpCustomer.
	descriptor table: customerTable.
	system createMappingIn: descriptor fromClassModelForAttributeNamed: #id.
	mapping := descriptor mappingForAttributeNamed: #id.
	self assert: mapping class = DirectMapping.
	self assert: mapping field = ownerId
]

{ #category : #Tests }
GlorpMappingFromClassModelTests >> testDirectMappingNameFieldNameComputation [
	| customerTable ownerId descriptor mapping customerModel |
	customerTable := system addEmptyTableNamed: 'GR_CUSTOMER'.
	ownerId := customerTable createFieldNamed: 'OWNER_ID' type: platform int4.
	customerModel := system addClassModelFor: GlorpCustomer.
	customerModel newAttributeNamed: #id type: Integer.
	descriptor := system addEmptyDescriptorFor: GlorpCustomer.
	descriptor table: customerTable.
	system attributeNameToFieldNameBlock: [:symbol | 'OWNER_ID'].
	system createMappingIn: descriptor fromClassModelForAttributeNamed: #id.
	mapping := descriptor mappingForAttributeNamed: #id.
	self assert: mapping class = DirectMapping.
	self assert: mapping field = ownerId
]

{ #category : #Tests }
GlorpMappingFromClassModelTests >> testOneToOneRelation [
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
]

{ #category : #Tests }
GlorpMappingFromClassModelTests >> testToManyRelation [
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
]
