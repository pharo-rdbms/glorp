testing
testValidateSelectorAccessExisting
	| descriptor table mapping system field |
	system := DynamicDescriptorSystem new.
	descriptor := system addEmptyDescriptorFor: GlorpCustomer.
	table := DatabaseTable named: 'Table1'.
	field := table createFieldNamed: 'one' type: OraclePlatform new integer.
	descriptor addTable: table.
	mapping := descriptor newMapping: DirectMapping.
	mapping from: #id to: field.
	mapping attribute useDirectAccess: false.
	mapping validate