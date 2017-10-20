tests
testMappingForField
	| descriptor mapping |
	descriptor := system descriptorFor: GlorpCustomer.
	mapping := descriptor 
				directMappingForField: ((system tableNamed: 'GR_CUSTOMER') fieldNamed: 'ID').
	self assert: mapping attributeName = #id