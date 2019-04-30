Class {
	#name : #GlorpDatabaseTableTest,
	#superclass : #GlorpMappingDBTest,
	#category : 'Glorp-Tests-Database'
}

{ #category : #tests }
GlorpDatabaseTableTest >> testFKUniqueNames [

	| platform contactTable linkTable companyId personId |
	platform := GlorpDatabaseLoginResource defaultPlatform.
	contactTable := DatabaseTable new
						name: 'CONTACT';
						yourself.
	contactTable createFieldNamed: 'ID' type: platform serial.

	linkTable := DatabaseTable new
						name: 'COMPANY_PERSON_LINK';
						yourself.
	companyId := linkTable createFieldNamed: 'COMPANY_ID' type: platform int4.
	personId := linkTable createFieldNamed: 'PERSON_ID' type: platform int4.
	linkTable
		addForeignKeyFrom: companyId to: (contactTable fieldNamed: 'ID');
		addForeignKeyFrom: personId to: (contactTable fieldNamed: 'ID').
	self assert: (linkTable foreignKeyConstraints collect: [:ea | ea name asSymbol]) asSet size = linkTable foreignKeyConstraints size.
]

{ #category : #tests }
GlorpDatabaseTableTest >> testIndexes [

	| platform contactTable idField name1Field name2Field |
	platform := GlorpDatabaseLoginResource defaultPlatform.
	contactTable := DatabaseTable new
						name: 'CONTACT';
						yourself.
	idField := (contactTable createFieldNamed: 'ID' type: platform serial) beIndexed.
	self assert: contactTable indexes size = 1.
	self assert: (contactTable hasIndexForField: idField).
	name1Field := contactTable createFieldNamed: 'NAME1' type: platform varchar.
	name2Field := contactTable createFieldNamed: 'NAME2' type: platform varchar.
	self deny: (contactTable hasIndexForField: name1Field).
	contactTable addIndexForFields: (Array with: name1Field with: name2Field).
	self assert: contactTable indexes size = 2.
	self assert: (contactTable hasIndexForField: idField).
	self assert: (contactTable hasIndexForField: name1Field).
	self assert: (contactTable hasIndexForField: name2Field).
]
