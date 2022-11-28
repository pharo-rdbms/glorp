Class {
	#name : #GlorpDatabaseIndexTest,
	#superclass : #GlorpMappingDBTest,
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #tests }
GlorpDatabaseIndexTest >> testNameGeneration [
	| platform table field index |
	platform := GlorpDatabaseLoginResource defaultPlatform.
	table := DatabaseTable new
						name: 'A_VERY_VERY_VERY_LONG_TABLE_NAME';
						yourself.
	field := table createFieldNamed: 'A_VERY_LONG_FIELD_NAME' type: platform serial.
	index := table addIndexForField: field.
	self assert: index name size <= platform maximumLengthOfTableName.
]

{ #category : #tests }
GlorpDatabaseIndexTest >> testNameGenerationLong [
	| platform table field index |
	"SQL Server has very long IDs"
	platform := SQLServerPlatform new.
	table := DatabaseTable new
						name: 'A_VERY_VERY_VERY_LONG_TABLE_NAME';
						yourself.
	field := table createFieldNamed: 'A_VERY_LONG_FIELD_NAME' type: platform serial.
	index := table addIndexForField: field.
	self assert: index name size <= platform maximumLengthOfTableName.
	self assert: index name = (table name, '_', field name, '_IDX').
]
