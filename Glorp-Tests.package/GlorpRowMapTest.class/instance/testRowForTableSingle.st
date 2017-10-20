tests
testRowForTableSingle
	| rowMapKey row |
	rowMapKey := RowMapKey new.
	rowMapKey key1: a1; key2: b1.
	row := rowMap findOrAddRowForTable: table1 withKey: rowMapKey.
	row2 := rowMap rowForTable: table1 withKey: rowMapKey.
	self assert: row == row2.