Class {
	#name : #GlorpRowMapForMementosTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'rowMap',
		'a1',
		'a2',
		'b1',
		'b2',
		'table1',
		'row1',
		'row2',
		'transaction',
		'c1',
		'c2'
	],
	#category : 'Glorp-Tests-Tests'
}

{ #category : #support }
GlorpRowMapForMementosTest >> setUp [
	super setUp.
	a1 := IdentityHashPrintingObject new.
	b1 := IdentityHashPrintingObject new.
	c1 := IdentityHashPrintingObject new.
	transaction := ObjectTransaction new.
	transaction register: a1.
	transaction register: b1.
	transaction register: c1.
	a2 := transaction undoMap at: a1.
	b2 := transaction undoMap at: b1.
	c2 := transaction undoMap at: c1.
	rowMap := RowMapForMementos withCorrespondenceMap: transaction undoMap.
	table1 := DatabaseTable new.
	row1 := 'row1'.
	row2 := 'row2'.
]

{ #category : #tests }
GlorpRowMapForMementosTest >> testAdjustMultipleRowMapKey [
	| rowMapKey adjustedKey  |
	rowMapKey := MultipleRowMapKey with: a1 with: b1 with: c1.
	adjustedKey := rowMapKey adjustIn: rowMap correspondenceMap.
	self assert: (adjustedKey keys includes: a2).
	self assert: (adjustedKey keys includes: b2).
	self assert: (adjustedKey keys includes: c2).
]

{ #category : #tests }
GlorpRowMapForMementosTest >> testAdjustRowMapKey [
	| rowMapKey adjustedKey  |
	rowMapKey := RowMapKey new.
	rowMapKey key1: a1; key2: b1.
	adjustedKey := rowMapKey adjustIn: rowMap correspondenceMap.
	self assert: (adjustedKey key1 == a2).
	self assert: (adjustedKey key2 == b2).
]

{ #category : #tests }
GlorpRowMapForMementosTest >> testReverseAdjustMultipleRowMapKey [
	| rowMapKey adjustedKey  |
	rowMapKey := MultipleRowMapKey with: a2 with: b2 with: c2.
	adjustedKey := rowMapKey reverseAdjustIn: rowMap.
	self assert: (adjustedKey keys includes: a1).
	self assert: (adjustedKey keys includes: b1).
	self assert: (adjustedKey keys includes: c1).
]

{ #category : #tests }
GlorpRowMapForMementosTest >> testReverseAdjustRowMapKey [
	| rowMapKey adjustedKey  |
	rowMapKey := RowMapKey new.
	rowMapKey key1: a2; key2: b2.
	adjustedKey := rowMapKey reverseAdjustIn: rowMap.
	self assert: (adjustedKey key1 == a1).
	self assert: (adjustedKey key2 == b1).
]

{ #category : #tests }
GlorpRowMapForMementosTest >> testRowForTableMultiple [
	| rowMapKey row |
	rowMapKey := MultipleRowMapKey with: a1 with: b1 with: c1.
	row := rowMap findOrAddRowForTable: table1 withKey: rowMapKey.
	row1 := rowMap findOrAddRowForTable: table1 withKey: rowMapKey.
	row2 := rowMap rowForTable: table1 withKey: rowMapKey.
	self assert: row == row1.
	self assert: row == row2.
]

{ #category : #tests }
GlorpRowMapForMementosTest >> testRowForTableSingle [
	| rowMapKey row |
	rowMapKey := RowMapKey new.
	rowMapKey key1: a1; key2: b1.
	row := rowMap findOrAddRowForTable: table1 withKey: rowMapKey.
	row1 := rowMap findOrAddRowForTable: table1 withKey: rowMapKey.
	row2 := rowMap rowForTable: table1 withKey: rowMapKey.
	self assert: row == row1.
	self assert: row == row2.
]
