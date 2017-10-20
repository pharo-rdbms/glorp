tests
testStoreWithRowMapKey

	| a b key1 key2 key3 table r1 r2 r3 |
	a := Object new.
	b := Object new.
	key1 := RowMapKey new key1: a; key2: b.
	key2 := RowMapKey new key1: a; key2: b.
	key3 := RowMapKey new key1: b; key2: a.
	table := DatabaseTable new.

	r1 := rowMap findOrAddRowForTable: table withKey: key1.
	r2 := rowMap findOrAddRowForTable: table withKey: key2.
	r3 := rowMap findOrAddRowForTable: table withKey: key3.

	self assert: r1 == r2.
	self assert: r2 == r3.
	self assert: r1 owner == key1.