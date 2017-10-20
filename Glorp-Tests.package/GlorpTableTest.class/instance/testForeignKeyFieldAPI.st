tests
testForeignKeyFieldAPI
	"SQLite does not support foreign keys but it will parse them;  this test passes on SQLite."

	| table1 table2 fieldCustAddr fieldAddrId constraint |
	table1 := DatabaseTable named: 'Customer'.
	(table1 createFieldNamed: 'ID' type: dbPlatform int4) bePrimaryKey.
	fieldCustAddr := table1 createFieldNamed: 'ADDRESS' type: dbPlatform int4.
	table2 := DatabaseTable named: 'Address'.
	fieldAddrId := (table2 createFieldNamed: 'ID' type: dbPlatform int4) bePrimaryKey.
	table2 createFieldNamed: 'Street' type: dbPlatform varChar.

	constraint := table1 addForeignKeyFrom: fieldCustAddr toTable: table2.
	self assert: (table2 fieldNamed: 'ID') = table1 foreignKeyConstraints first targetFields first.
	self assert: constraint name =  'Customer_A_TO_Address_ID_REF1'.

	table1 := DatabaseTable named: 'Customer'.
	(table1 createFieldNamed: 'ID' type: dbPlatform int4) bePrimaryKey.
	fieldCustAddr := table1 createFieldNamed: 'ADDRESS' type: dbPlatform int4.
	table2 := DatabaseTable named: 'Address'.
	fieldAddrId := (table2 createFieldNamed: 'ID' type: dbPlatform int4) bePrimaryKey.
	table2 createFieldNamed: 'Street' type: dbPlatform varChar.

	table1 addForeignKeyFrom: fieldCustAddr to: fieldAddrId.
	self assert: (table2 fieldNamed: 'ID') = table1 foreignKeyConstraints first targetFields first.