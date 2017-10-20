tests
testRowForTableMultiple
	| rowMapKey row |
	rowMapKey := MultipleRowMapKey with: a1 with: b1 with: c1.
	row := rowMap findOrAddRowForTable: table1 withKey: rowMapKey.
	row1 := rowMap findOrAddRowForTable: table1 withKey: rowMapKey.
	row2 := rowMap rowForTable: table1 withKey: rowMapKey.
	self assert: row == row1.
	self assert: row == row2.