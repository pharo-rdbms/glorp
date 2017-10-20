Tests
testDirectMappingNameFieldNameComputation
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