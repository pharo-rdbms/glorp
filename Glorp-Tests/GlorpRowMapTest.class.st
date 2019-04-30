Class {
	#name : #GlorpRowMapTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'rowMap',
		'a1',
		'b1',
		'table1',
		'row2',
		'platform'
	],
	#category : 'Glorp-Tests-Tests'
}

{ #category : #support }
GlorpRowMapTest >> setUp [
	super setUp.
	a1 := IdentityHashPrintingObject new.
	b1 := IdentityHashPrintingObject new.
	rowMap := RowMap new.
	table1 := DatabaseTable new name: 'SomeTable'.
	platform := OraclePlatform new.
	table1 addField: (DatabaseField named: 'ONE_ID' type: platform integer) bePrimaryKey.
	table1 addField: (DatabaseField named: 'OTHER_ID' type: platform integer).
	table1 addField: (DatabaseField named: 'KEY' type: platform integer) bePrimaryKey.
	row2 := 'row2'.
]

{ #category : #tests }
GlorpRowMapTest >> testCollapseMatchingInsertsAndDeletes [
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
]

{ #category : #tests }
GlorpRowMapTest >> testCollapseMatchingInsertsAndDeletesWithUnknownFields [
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
]

{ #category : #tests }
GlorpRowMapTest >> testRowForTableSingle [
	| rowMapKey row |
	rowMapKey := RowMapKey new.
	rowMapKey key1: a1; key2: b1.
	row := rowMap findOrAddRowForTable: table1 withKey: rowMapKey.
	row2 := rowMap rowForTable: table1 withKey: rowMapKey.
	self assert: row == row2.
]
