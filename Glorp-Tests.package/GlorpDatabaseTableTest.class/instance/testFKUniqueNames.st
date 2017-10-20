tests
testFKUniqueNames

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