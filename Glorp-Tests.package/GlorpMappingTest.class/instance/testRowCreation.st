tests
testRowCreation

	| descriptor person row table  |
	descriptor := system descriptorFor: GlorpPerson.
	person := GlorpPerson example1.
	rowMap := RowMap new.
	table := system existingTableNamed: 'PERSON'.
	descriptor createRowsFor: person in: rowMap.
	self assert: (rowMap includesRowForTable: table withKey: person).
	row := rowMap rowForTable: table withKey: person.
	self assert: (row at: (table fieldNamed: 'ID')) = person id.
	self assert: (row at: (table fieldNamed: 'NAME')) = person name.
	self assert: rowMap numberOfEntries = 2.