tests
testNameGeneration
	| platform table field index |
	platform := GlorpDatabaseLoginResource defaultPlatform.
	table := DatabaseTable new
						name: 'A_VERY_VERY_VERY_LONG_TABLE_NAME';
						yourself.
	field := table createFieldNamed: 'A_VERY_LONG_FIELD_NAME' type: platform serial.
	index := table addIndexForField: field.
	self assert: index name size <= platform maximumLengthOfTableName.