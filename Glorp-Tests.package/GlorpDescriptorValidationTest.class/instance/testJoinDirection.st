testing
testJoinDirection
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