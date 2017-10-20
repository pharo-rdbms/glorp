tests
testMultipleTableCreation
	
	| descriptor table passenger table2 row1 row2 |
	descriptor := system descriptorFor: GlorpPassenger.
	passenger := GlorpPassenger example1.
	rowMap := RowMap new.
	table := system existingTableNamed: 'PASSENGER'.
	table2 := system existingTableNamed: 'FREQUENT_FLYER'.
	descriptor createRowsFor: passenger in: rowMap.
	self assert: (rowMap includesRowForTable: table withKey: passenger).
	self assert: (rowMap includesRowForTable: table2 withKey: passenger).
	row1 := rowMap rowForTable: table withKey: passenger.
	self assert: (row1 at: (table fieldNamed: 'ID'))
			= passenger id.
	self assert: (row1 at: (table fieldNamed: 'NAME'))
			= passenger name.
	row2 := rowMap rowForTable: table2 withKey: passenger.
	self assert: (row2 at: (table2 fieldNamed: 'ID'))
			= passenger id.
	self assert: (row2 at: (table2 fieldNamed: 'POINTS')) = passenger frequentFlyerPoints.
	self assert: rowMap numberOfEntries = 3