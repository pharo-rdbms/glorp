tests
testAllMappingsForField
	| descriptor mappings |
	descriptor := system descriptorFor: GlorpCustomer.
	mappings := descriptor 
				allMappingsForField: ((system tableNamed: 'GR_CUSTOMER') fieldNamed: 'ID').
	self assert: mappings first attributeName = #id