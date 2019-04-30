Class {
	#name : #GlorpDescriptorValidationTest,
	#superclass : #TestCase,
	#category : 'Glorp-Tests-Tests'
}

{ #category : #testing }
GlorpDescriptorValidationTest >> testJoinDirection [
	| descriptor table1 table2 mapping system descriptor2 |
	system := DynamicDescriptorSystem new.
	descriptor := system addEmptyDescriptorFor: GlorpCustomer.
	descriptor2 := system addEmptyDescriptorFor: GlorpVideoStore.
	table1 := DatabaseTable named: 'Table1'.
	table1 createFieldNamed: 'one' type: nil.
	table2 := DatabaseTable named: 'Table2'.
	table2 createFieldNamed: 'two' type: nil.
	descriptor addTable: table1.
	descriptor2  addTable: table2.
	mapping := descriptor newMapping: OneToOneMapping.
	mapping attributeName: #accounts.
	mapping referenceClass: GlorpVideoStore.
	mapping join: (Join from: (table1 fieldNamed: 'one') to: (table2 fieldNamed: 'two')).
	mapping validate.

	mapping := descriptor newMapping: OneToOneMapping.
	mapping attributeName: #bar.
	mapping referenceClass: GlorpVideoStore.
	mapping join: (Join from: (table2 fieldNamed: 'two') to: (table1 fieldNamed: 'one')).
	self should: [mapping validate] raise: Dialect error.
]

{ #category : #testing }
GlorpDescriptorValidationTest >> testValidateDirectInstvarAccessExisting [
	| descriptor table mapping system field |
	system := DynamicDescriptorSystem new.
	descriptor := system addEmptyDescriptorFor: GlorpCustomer.
	table := DatabaseTable named: 'Table1'.
	field := table createFieldNamed: 'one' type: OraclePlatform new integer.
	descriptor addTable: table.
	mapping := descriptor newMapping: DirectMapping.
	mapping from: #id to: field.
	mapping validate
]

{ #category : #testing }
GlorpDescriptorValidationTest >> testValidateDirectInstvarAccessNonExisting [
	| descriptor table mapping system field |
	system := DynamicDescriptorSystem new.
	descriptor := system addEmptyDescriptorFor: GlorpCustomer.
	table := DatabaseTable named: 'Table1'.
	field := table createFieldNamed: 'one' type: OraclePlatform new integer.
	descriptor addTable: table.
	mapping := descriptor newMapping: DirectMapping.
	mapping from: #bar to: field.
	self should: [mapping validate] raise: Dialect error
]

{ #category : #testing }
GlorpDescriptorValidationTest >> testValidateSelectorAccessExisting [
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
]

{ #category : #testing }
GlorpDescriptorValidationTest >> testValidateSelectorAccessNonExisting [
	| descriptor table mapping system field |
	system := DynamicDescriptorSystem new.
	descriptor := system addEmptyDescriptorFor: GlorpCustomer.
	table := DatabaseTable named: 'Table1'.
	field := table createFieldNamed: 'one' type: OraclePlatform new integer.
	descriptor addTable: table.
	mapping := descriptor newMapping: DirectMapping.
	mapping from: #foo to: field.
	mapping attribute useDirectAccess: false.
	self should: [mapping validate] raise: Dialect error
]

{ #category : #testing }
GlorpDescriptorValidationTest >> testValidatingExistingDescriptors [
	| session |
	session := GlorpSessionResource current newSession.
	GlorpTestDescriptorSystem allSubclasses do: [:each |
		session system: (each forPlatform: (OraclePlatform new)).
		session system validate].
]
