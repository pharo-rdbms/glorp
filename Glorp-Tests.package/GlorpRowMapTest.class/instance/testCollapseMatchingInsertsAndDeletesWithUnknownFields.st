tests
testCollapseMatchingInsertsAndDeletesWithUnknownFields
	"In 8.0.1 and after, we no longer throw an error for unknown values in the update row, believing the condition can never happen in real life.  This test sets up the condition and now checks that no error is raised by it.  It stays here just as info, and for reuse if our assumption is ever wrong."

	| c1 key1 key2 row1 |
	c1 := Object new.
	key1 := RowMapKey new key1: a1; key2: b1.
	key2 := RowMapKey new key1: a1; key2: c1.
	row1 := rowMap findOrAddRowForTable: table1 withKey: key1.
	row1 atFieldNamed: 'ONE_ID' put: 99.
	row1 atFieldNamed: 'OTHER_ID' put: 98.
	row1 atFieldNamed: 'KEY' put: 5.
	row2 := rowMap findOrAddRowForTable: table1 withKey: key2.
	row2 atFieldNamed: 'ONE_ID' put: 99.
	row2 atFieldNamed: 'KEY' put: 5.
	row1 forDeletion: true.
	self shouldnt: [rowMap collapseMatchingInsertsAndDeletes] raise: Dialect error.