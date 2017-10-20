tests
testMultipleTableCreationWithOneMissing
	
	| descriptor table passenger table2 row1 |
	descriptor := system descriptorFor: GlorpPassenger.
	passenger := GlorpPassenger example1.
	passenger frequentFlyerPoints: nil.
	passenger airline: nil.
	rowMap := RowMap new.
	table := system existingTableNamed: 'PASSENGER'.
	table2 := system existingTableNamed: 'FREQUENT_FLYER'.
	descriptor createRowsFor: passenger in: rowMap.
	self assert: (rowMap includesRowForTable: table withKey: passenger).
	self deny: (rowMap includesRowForTable: table2 withKey: passenger).
	row1 := rowMap rowForTable: table withKey: passenger.
	self assert: (row1 at: (table fieldNamed: 'ID'))
			= passenger id.
	self assert: (row1 at: (table fieldNamed: 'NAME'))
			= passenger name.
	self assert: rowMap numberOfEntries = 1.