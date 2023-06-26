Class {
	#name : #GlorpTableTest,
	#superclass : #GlorpDatabaseBasedTest,
	#instVars : [
		'descriptors',
		'dbPlatform'
	],
	#category : #'Glorp-Unit-Tests-Tests'
}

{ #category : #support }
GlorpTableTest >> keywordForConstraintsWhenDropping: aConstraint onPlatform: aDatabasePlatform [
	"This method returns the term to test against independently of #writeConstraintToDrop:onStream:.  The logic is that ANSI uses 'DROP CONSTRAINT but MySQL uses
		'DROP PRIMARY KEY' for primary key constraints (and then says don't name the constraint name in the drop statement!)
		'DROP FOREIGN KEY'  for foreign key constraints
		'DROP KEY' for unique constraints (it also supports DROP INDEX for this)"

	(aDatabasePlatform isKindOf: MySQLPlatform) ifFalse: [^'CONSTRAINT'].
	aConstraint isForeignKeyConstraint ifTrue: [^'FOREIGN KEY'].
	aConstraint isPrimaryKeyConstraint ifTrue: [^'PRIMARY KEY'].
	^'KEY'
]

{ #category : #support }
GlorpTableTest >> setUp [
	super setUp.
	descriptors := system allDescriptors.
	dbPlatform := system platform.
	GlorpInMemorySequenceDatabaseType reset
]

{ #category : #tests }
GlorpTableTest >> testBasicSequencing [

	| row |
	row := DatabaseRow newForTable: (system tableNamed: 'STUFF').
	row preWriteAssignSequencesUsing: nil.
	row postWriteAssignSequencesUsing: nil.
	self assert: (row at: ((system tableNamed: 'STUFF') fieldNamed: 'ID')) equals: 1
]

{ #category : #tests }
GlorpTableTest >> testCircularFieldRefs [

	| field table1 table2 |
	table1 := DatabaseTable named: 'BAR'.
	field := table1 createFieldNamed: 'FOO' type: dbPlatform int4.
	table2 := DatabaseTable named: 'BLETCH'.
	table1 addForeignKeyFrom: field to: (table2 createFieldNamed: 'FLIRP' type: dbPlatform int4).
	self assert: (table2 fieldNamed: 'FLIRP') equals: table1 foreignKeyConstraints first targetFields first
]

{ #category : #tests }
GlorpTableTest >> testConstraintCreation [
	| constraint dropWord |
	constraint := ForeignKeyConstraint
		sourceField: ((system tableNamed: 'BANK_ACCT') fieldNamed: 'BANK_CODE')
		targetField: ((system tableNamed: 'PERSON') fieldNamed: 'ID').
	self assert: constraint creationString =
		( 'CONSTRAINT ', constraint name, ' FOREIGN KEY (BANK_CODE) REFERENCES PERSON (ID)').
	dropWord := self keywordForConstraintsWhenDropping: constraint onPlatform: dbPlatform.	
	dbPlatform supportsAlterTableForConstraints ifTrue:
		[self assert: constraint dropString =
			( 'ALTER TABLE BANK_ACCT DROP ', dropWord, ' ', constraint name)].
	constraint := ForeignKeyConstraint
		sourceField: ((system tableNamed: 'BANK_ACCT') fieldNamed: 'BANK_CODE')
		targetField: ((system tableNamed: 'PERSON') fieldNamed: 'ID')
		suffixExpression: 'ON DELETE CASCADE'.
	self assert: constraint creationString = ('CONSTRAINT ', constraint name, ' FOREIGN KEY (BANK_CODE) REFERENCES PERSON (ID) ON DELETE CASCADE').
	dbPlatform supportsAlterTableForConstraints ifTrue:
		[self assert: constraint dropString = ('ALTER TABLE BANK_ACCT DROP ', dropWord, ' ',  constraint name)].
]

{ #category : #tests }
GlorpTableTest >> testConstraintNonCreation [

	| constraint |
	constraint := ForeignKeyConstraint
		sourceField: ((system tableNamed: 'BANK_ACCT') fieldNamed: 'BANK_CODE')
		targetField: ((system tableNamed: 'PERSON') fieldNamed: 'ID').
	constraint shouldCreateInDatabase: false.
	self assert: constraint creationString equals: ''.
	self assert: constraint dropString equals: ''
]

{ #category : #tests }
GlorpTableTest >> testFieldTable [

	| field table |
	field := DatabaseField named: 'FOO' type: dbPlatform int4.
	table := DatabaseTable named: 'BAR'.
	table addField: field.
	self assert: (table fieldNamed: 'FOO') equals: field
]

{ #category : #tests }
GlorpTableTest >> testForeignKeyFieldAPI [
	"SQLite does not support foreign keys but it will parse them;  this test passes on SQLite."

	| table1 table2 fieldCustAddr fieldAddrId constraint |
	table1 := DatabaseTable named: 'Customer'.
	(table1 createFieldNamed: 'ID' type: dbPlatform int4) bePrimaryKey.
	fieldCustAddr := table1 createFieldNamed: 'ADDRESS' type: dbPlatform int4.
	table2 := DatabaseTable named: 'Address'.
	fieldAddrId := (table2 createFieldNamed: 'ID' type: dbPlatform int4) bePrimaryKey.
	table2 createFieldNamed: 'Street' type: dbPlatform varChar.

	constraint := table1 addForeignKeyFrom: fieldCustAddr toTable: table2.
	self assert: (table2 fieldNamed: 'ID') equals: table1 foreignKeyConstraints first targetFields first.
	self assert: constraint name equals: 'Customer_A_TO_Address_ID_REF1'.

	table1 := DatabaseTable named: 'Customer'.
	(table1 createFieldNamed: 'ID' type: dbPlatform int4) bePrimaryKey.
	fieldCustAddr := table1 createFieldNamed: 'ADDRESS' type: dbPlatform int4.
	table2 := DatabaseTable named: 'Address'.
	fieldAddrId := (table2 createFieldNamed: 'ID' type: dbPlatform int4) bePrimaryKey.
	table2 createFieldNamed: 'Street' type: dbPlatform varChar.

	table1 addForeignKeyFrom: fieldCustAddr to: fieldAddrId.
	self assert: (table2 fieldNamed: 'ID') equals: table1 foreignKeyConstraints first targetFields first
]

{ #category : #tests }
GlorpTableTest >> testPrimaryKeyFields [

	| pkFields table |
	table := system tableNamed: 'BANK_TRANS'.
	pkFields := table primaryKeyFields.
	self assert: pkFields size equals: 1.
	self assert: (pkFields at: 1) == (table fieldNamed: 'ID')
]

{ #category : #tests }
GlorpTableTest >> testPrimaryKeyFields2 [

	| table field |
	table := DatabaseTable new.
	field := (DatabaseField named: 'FRED' type: (dbPlatform varChar: 10))
		bePrimaryKey.
	table addField: field.
	self assert: table primaryKeyFields size equals: 1.
	self assert: (table primaryKeyFields at: 1) == field.
]

{ #category : #tests }
GlorpTableTest >> testPrimaryKeyFieldsNoPK [

	| pkFields table |
	table := system tableNamed: 'CUSTOMER_ACCT_LINK'.
	pkFields := table primaryKeyFields.
	self assert: pkFields size equals: 0.
]

{ #category : #tests }
GlorpTableTest >> testPrintingWithParent [

	| t t1 |
	t := system tableNamed: 'GR_CUSTOMER'.
	t1 := t copy.
	t1 parent: t.
	t1 name: 'foo'.
	self assert: t1 sqlTableName equals: 'GR_CUSTOMER foo'.
]

{ #category : #tests }
GlorpTableTest >> testPrintingWithoutParent [

	| t |
	t := system tableNamed: 'GR_CUSTOMER'.
	self assert: t sqlTableName equals: 'GR_CUSTOMER'
]

{ #category : #tests }
GlorpTableTest >> testRowCreation [

	| row |
	row := system examplePersonRow1.
	self assert: (row at: (row table fieldNamed: 'ID')) equals: 3
]

{ #category : #tests }
GlorpTableTest >> testTwoSequences [

	| row1 row2 table idField |
	table := system tableNamed: 'STUFF'.
	row1 := DatabaseRow newForTable: table.
	row2 := DatabaseRow newForTable: table.
	row1 preWriteAssignSequencesUsing: nil.
	row1 postWriteAssignSequencesUsing: nil.
	row2 preWriteAssignSequencesUsing: nil.
	row2 postWriteAssignSequencesUsing: nil.
	idField := table fieldNamed: 'ID'.
	self assert: (row1 at: idField) equals: 1.
	self assert: (row2 at: idField) equals: 2
]
