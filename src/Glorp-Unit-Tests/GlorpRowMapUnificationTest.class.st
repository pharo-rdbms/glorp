Class {
	#name : #GlorpRowMapUnificationTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		't1',
		't2',
		't3',
		'f1',
		'f2',
		'f3',
		'o1',
		'o2',
		'o3',
		'rowMap',
		'platform'
	],
	#category : #'Glorp-Unit-Tests-Tests'
}

{ #category : #running }
GlorpRowMapUnificationTest >> setUp [

	super setUp.
	platform := GlorpDatabaseLoginResource defaultPlatform.
	t1 := DatabaseTable named: 'T1'.
	t2 := DatabaseTable named: 'T2'.
	t3 := DatabaseTable named: 'T3'.
	f1 := t1 createFieldNamed: 'f1' type: (platform varChar: 10).
	f2 := t2 createFieldNamed: 'f2' type: (platform varChar: 10).
	f3 := t3 createFieldNamed: 'f3'  type: (platform varChar: 10).
	rowMap := RowMap new.
	o1 := 'one'.
	o2 := 'two'.
	o3 := 'three'
]

{ #category : #tests }
GlorpRowMapUnificationTest >> testDoubleRowUnificationDifferentRows [

	rowMap
		unifyField: f1
		key: o1
		withField: f2
		key: o2.
	rowMap
		unifyField: f3
		key: o3
		withField: f2
		key: o2.
	(rowMap rowForTable: t1 withKey: o1) at: f1 put: 42.
	self assert: ((rowMap rowForTable: t1 withKey: o1) at: f1) equals: 42.
	self assert: ((rowMap rowForTable: t2 withKey: o2) at: f2) equals: 42.
	self assert: ((rowMap rowForTable: t3 withKey: o3) at: f3) equals: 42
]

{ #category : #tests }
GlorpRowMapUnificationTest >> testDoubleRowUnificationDifferentRows2 [

	rowMap
		unifyField: f1
		key: o1
		withField: f2
		key: o2.
	rowMap
		unifyField: f2
		key: o2
		withField: f3
		key: o3.
	(rowMap rowForTable: t1 withKey: o1) at: f1 put: 42.
	self assert: ((rowMap rowForTable: t1 withKey: o1) at: f1) equals: 42.
	self assert: ((rowMap rowForTable: t2 withKey: o2) at: f2) equals: 42.
	self assert: ((rowMap rowForTable: t3 withKey: o3) at: f3) equals: 42
]

{ #category : #tests }
GlorpRowMapUnificationTest >> testDoubleRowUnificationDifferentRows3 [

	rowMap
		unifyField: f1
		key: o1
		withField: f2
		key: o2.
	rowMap
		unifyField: f2
		key: o2
		withField: f3
		key: o3.
	(rowMap rowForTable: t3 withKey: o3) at: f3 put: 42.
	self assert: ((rowMap rowForTable: t1 withKey: o1) at: f1) equals: 42.
	self assert: ((rowMap rowForTable: t2 withKey: o2) at: f2) equals: 42.
	self assert: ((rowMap rowForTable: t3 withKey: o3) at: f3) equals: 42
]

{ #category : #tests }
GlorpRowMapUnificationTest >> testDoubleRowUnificationDifferentRows4 [
	| t4 f4 o4 |
	t4 := DatabaseTable named: 'T4'.
	f4 := t4 createFieldNamed: 'f4' type: (platform varChar: 10).
	o4 := 'four'.
	rowMap
		unifyField: f1
		key: o1
		withField: f2
		key: o2.
	rowMap
		unifyField: f3
		key: o3
		withField: f4
		key: o4.
	rowMap
		unifyField: f2
		key: o2
		withField: f3
		key: o3.
	(rowMap rowForTable: t1 withKey: o1) at: f1 put: 42.
	self assert: ((rowMap rowForTable: t1 withKey: o1) at: f1) equals: 42.
	self assert: ((rowMap rowForTable: t2 withKey: o2) at: f2) equals: 42.
	self assert: ((rowMap rowForTable: t3 withKey: o3) at: f3) equals: 42.
	self assert: ((rowMap rowForTable: t4 withKey: o4) at: f4) equals: 42
]

{ #category : #tests }
GlorpRowMapUnificationTest >> testDoubleRowUnificationSameRow [

	rowMap
		unifyField: f1
		key: o1
		withField: f2
		key: o2.
	rowMap
		unifyField: f1
		key: o1
		withField: f2
		key: o2.
	(rowMap rowForTable: t1 withKey: o1) at: f1 put: 42.
	self assert: ((rowMap rowForTable: t1 withKey: o1) at: f1) equals: 42.
	self assert: ((rowMap rowForTable: t2 withKey: o2) at: f2) equals: 42
]

{ #category : #tests }
GlorpRowMapUnificationTest >> testDoubleRowUnificationSameRow2 [

	rowMap
		unifyField: f1
		key: o1
		withField: f2
		key: o2.
	rowMap
		unifyField: f2
		key: o2
		withField: f1
		key: o1.
	(rowMap rowForTable: t1 withKey: o1) at: f1 put: 42.
	self assert: ((rowMap rowForTable: t1 withKey: o1) at: f1) equals: 42.
	self assert: ((rowMap rowForTable: t2 withKey: o2) at: f2) equals: 42
]

{ #category : #tests }
GlorpRowMapUnificationTest >> testIteration [

	| rows r1 r2 r3 count |
	r1 := rowMap findOrAddRowForTable: t1 withKey: o1.
	r2 := rowMap findOrAddRowForTable: t1 withKey: o2.
	r3 := rowMap findOrAddRowForTable: t2 withKey: o2.
	rows := IdentitySet new.
	count := 0.
	rowMap rowsDo: [:each |
		count := count + 1.
		rows add: each].
	self assert: count equals: 3.
	self assert: (rows includes: r1).
	self assert: (rows includes: r3).
	self assert: (rows includes: r2)
]

{ #category : #'tests - related rows' }
GlorpRowMapUnificationTest >> testRelatedRowInternal [

	| cf1 r1 r2 r3 |
	cf1 := t1 createFieldNamed: 'cf1' type: (platform varChar: 10).
	t1 addForeignKeyFrom: cf1 to: f1.
	rowMap
		unifyField: f1
		key: o1
		withField: cf1
		key: o2.
	rowMap
		unifyField: f1
		key: o1
		withField: cf1
		key: o3.
	r1 := rowMap rowForTable: t1 withKey: o1.
	r1 at: f1 put: o1.
	r2 := rowMap rowForTable: t1 withKey: o2.
	r2 at: f1 put: o2.
	r3 := rowMap rowForTable: t1 withKey: o3.
	r3 at: f1 put: o3.
	self assert: (r1 relatedRowsIn: rowMap) isEmpty.
	self assert: (r2 relatedRowsIn: rowMap) asArray equals: (Array with: r1).
	self assert: (r3 relatedRowsIn: rowMap) asArray equals: (Array with: r1)
]

{ #category : #tests }
GlorpRowMapUnificationTest >> testStoreThenUnify [
	rowMap at: f1 key: o1 put: 12.
	rowMap
		unifyField: f2
		key: o2
		withField: f3
		key: o3.
	rowMap
		unifyField: f1
		key: o1
		withField: f2
		key: o2.
	self assert: ((rowMap rowForTable: t1 withKey: o1) at: f1) equals: 12.
	self assert: ((rowMap rowForTable: t2 withKey: o2) at: f2) equals: 12.
	self assert: ((rowMap rowForTable: t3 withKey: o3) at: f3) equals: 12
]

{ #category : #tests }
GlorpRowMapUnificationTest >> testStoreWithRowMapKey [

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
]

{ #category : #'tests - transformation' }
GlorpRowMapUnificationTest >> testUnifyExtraOnSourceSideWithTransformationBeforeStoreForward [

	rowMap
		unifyField: f1
		key: o1
		withField: f2
		key: o2
		transformationForward: [:value | value * 2]
		inverse: [:value | value / 2].
	rowMap
		unifyField: f1
		key: o1
		withField: f3
		key: o3.
	(rowMap findOrAddRowForTable: t1 withKey: o1) at: f1 put: 12.
	self assert: ((rowMap rowForTable: t1 withKey: o1) at: f1) equals: 12.
	self assert: ((rowMap rowForTable: t2 withKey: o2) at: f2) equals: 24.
	self assert: ((rowMap rowForTable: t3 withKey: o3) at: f3) equals: 12
]

{ #category : #'tests - transformation' }
GlorpRowMapUnificationTest >> testUnifyExtraOnSourceSideWithTransformationBeforeStoreInverse [

	rowMap
		unifyField: f1
		key: o1
		withField: f2
		key: o2
		transformationForward: [:value | value * 2]
		inverse: [:value | value / 2].
	rowMap
		unifyField: f1
		key: o1
		withField: f3
		key: o3.
	(rowMap findOrAddRowForTable: t2 withKey: o2) at: f2 put: 24.
	self assert: ((rowMap rowForTable: t1 withKey: o1) at: f1) equals: 12.
	self assert: ((rowMap rowForTable: t2 withKey: o2) at: f2) equals: 24.
	self assert: ((rowMap rowForTable: t3 withKey: o3) at: f3) equals: 12
]

{ #category : #'tests - transformation' }
GlorpRowMapUnificationTest >> testUnifyExtraOnTargetSideWithTransformationBeforeStoreForward [

	rowMap
		unifyField: f1
		key: o1
		withField: f2
		key: o2
		transformationForward: [:value | value * 2]
		inverse: [:value | value / 2].
	rowMap
		unifyField: f2
		key: o2
		withField: f3
		key: o3.
	(rowMap findOrAddRowForTable: t1 withKey: o1) at: f1 put: 12.
	self assert: ((rowMap rowForTable: t1 withKey: o1) at: f1) equals: 12.
	self assert: ((rowMap rowForTable: t2 withKey: o2) at: f2) equals: 24.
	self assert: ((rowMap rowForTable: t3 withKey: o3) at: f3) equals: 24
]

{ #category : #'tests - transformation' }
GlorpRowMapUnificationTest >> testUnifyExtraOnTargetSideWithTransformationBeforeStoreInverse [

	rowMap
		unifyField: f1
		key: o1
		withField: f2
		key: o2
		transformationForward: [:value | value * 2]
		inverse: [:value | value / 2].
	rowMap
		unifyField: f2
		key: o2
		withField: f3
		key: o3.
	(rowMap findOrAddRowForTable: t2 withKey: o2) at: f2 put: 24.
	self assert: ((rowMap rowForTable: t1 withKey: o1) at: f1) equals: 12.
	self assert: ((rowMap rowForTable: t2 withKey: o2) at: f2) equals: 24.
	self assert: ((rowMap rowForTable: t3 withKey: o3) at: f3) equals: 24
]

{ #category : #'tests - transformation' }
GlorpRowMapUnificationTest >> testUnifyWithTransformationAfterStoreForward [

	(rowMap findOrAddRowForTable: t1 withKey: o1) at: f1 put: 12.
	rowMap
		unifyField: f1
		key: o1
		withField: f2
		key: o2
		transformationForward: [:value | value * 2]
		inverse: [:value | value / 2].
	self assert: ((rowMap rowForTable: t1 withKey: o1) at: f1) equals: 12.
	self assert: ((rowMap rowForTable: t2 withKey: o2) at: f2) equals: 24
]

{ #category : #'tests - transformation' }
GlorpRowMapUnificationTest >> testUnifyWithTransformationAfterStoreInverse [
	"This is a little tricky. If we set the value first, then impose the constraint, then we're effectively doubling what was set. I think this is actually right, but also a very weird case on top of weird scenarios to begin with"

	(rowMap findOrAddRowForTable: t2 withKey: o2) at: f2 put: 12.
	rowMap
		unifyField: f1
		key: o1
		withField: f2
		key: o2
		transformationForward: [:value | value * 2]
		inverse: [:value | value / 2].	"Note: vs. the 6 and 12 you might otherwise expect"
	self assert: ((rowMap rowForTable: t1 withKey: o1) at: f1) equals: 12.
	self assert: ((rowMap rowForTable: t2 withKey: o2) at: f2) equals: 24
]

{ #category : #'tests - transformation' }
GlorpRowMapUnificationTest >> testUnifyWithTransformationBeforeStoreForward [

	rowMap
		unifyField: f1
		key: o1
		withField: f2
		key: o2
		transformationForward: [:value | value * 2]
		inverse: [:value | value / 2].
	(rowMap findOrAddRowForTable: t1 withKey: o1) at: f1 put: 12.
	self assert: ((rowMap rowForTable: t1 withKey: o1) at: f1) equals: 12.
	self assert: ((rowMap rowForTable: t2 withKey: o2) at: f2) equals: 24
]

{ #category : #'tests - transformation' }
GlorpRowMapUnificationTest >> testUnifyWithTransformationBeforeStoreInverse [

	rowMap
		unifyField: f1
		key: o1
		withField: f2
		key: o2
		transformationForward: [:value | value * 2]
		inverse: [:value | value / 2].
	rowMap at: f2 key: o2 put: 12.
	self assert: ((rowMap rowForTable: t1 withKey: o1) at: f1) equals: 6.
	self assert: ((rowMap rowForTable: t2 withKey: o2) at: f2) equals: 12
]
