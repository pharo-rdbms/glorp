tests
testCollapseMatchingInsertsAndDeletes
	| c1 key1 key2 row1 remainingRow updates |
	c1 := Object new.
	key1 := RowMapKey new key1: a1; key2: b1.
	key2 := RowMapKey new key1: a1; key2: c1.
	row1 := rowMap findOrAddRowForTable: table1 withKey: key1.
	row1 atFieldNamed: 'ONE_ID' put: 99.
	row1 atFieldNamed: 'OTHER_ID' put: 98.
	row1 atFieldNamed: 'KEY' put: 5.
	row2 := rowMap findOrAddRowForTable: table1 withKey: key2.
	row2 atFieldNamed: 'ONE_ID' put: 99.
	row2 atFieldNamed: 'OTHER_ID' put: 14.
	row2 atFieldNamed: 'KEY' put: 5.
	row1 forDeletion: true.
	updates := rowMap collapseMatchingInsertsAndDeletes.
	self assert: rowMap numberOfEntries = 1.
	self assert: updates size = 1.
	self assert: updates asArray first = row2.
	remainingRow := rowMap rowForTable: table1 withKey: key2 ifAbsent: [self assert: false].
	rowMap rowForTable: table1 withKey: key1 ifPresent: [:shouldntBeThereAnyMore | self assert: false].
	self assert: (remainingRow atFieldNamed: 'ONE_ID') = 99.
	self assert: (remainingRow atFieldNamed: 'OTHER_ID') = 14.
	self assert: (remainingRow atFieldNamed: 'KEY') = 5.
	self assert: remainingRow owner = key2.