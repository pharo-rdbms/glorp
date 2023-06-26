Class {
	#name : #GlorpCommitOrderTest,
	#superclass : #GlorpDatabaseBasedTest,
	#instVars : [
		't1',
		't2',
		't3',
		't1id',
		't2id',
		't3id',
		'platform'
	],
	#category : #'Glorp-Unit-Tests-Tests'
}

{ #category : #running }
GlorpCommitOrderTest >> setUp [

	super setUp.
	platform := system platform.
	t1 := DatabaseTable new name: 'T1'.
	t1id := (t1 createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	t2 := DatabaseTable new name: 'T2'.
	t2id := (t2 createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	t3 := DatabaseTable new name: 'T3'.
	t3id := (t3 createFieldNamed: 'ID' type: platform int4) bePrimaryKey
]

{ #category : #tests }
GlorpCommitOrderTest >> testCommitOrder [

	| sorter |
	sorter := TableSorter for: (Array with: (system tableNamed: 'BANK_TRANS') with: (system tableNamed: 'GR_CUSTOMER')).
	self assert: sorter sort first name equals: 'GR_CUSTOMER'
]

{ #category : #tests }
GlorpCommitOrderTest >> testCommitOrder2 [
	"Test for a cycle between t1 and t2 with t3 also pointing to both. Order of t1, t2 is indeterminate, but t3 should be last"

	| table1 table1id table2 table2id t2fk t3fk t3fk2 sorter t1fk |
	table1 := DatabaseTable new name: 'T1'.
	table1id := (table1 createFieldNamed: 'ID' type: platform inMemorySequence) bePrimaryKey.
	table2 := DatabaseTable new name: 'T2'.
	table2id := (table2 createFieldNamed: 'ID' type: platform inMemorySequence) bePrimaryKey.

	t1fk := table1 createFieldNamed: 'T2_ID' type: platform int4.
	table1 addForeignKeyFrom: t1fk to: table2id.
	t2fk := table2 createFieldNamed: 'T1_ID' type: platform int4.
	table2 addForeignKeyFrom: t2fk to: table1id.

	t3 := DatabaseTable new name: 'T3'.
	t3fk := t3 createFieldNamed: 'T2_ID' type: platform int4.
	t3 addForeignKeyFrom: t3fk to: table2id.
	t3fk2 := t3 createFieldNamed: 'T1_ID' type: platform int4.
	t3 addForeignKeyFrom: t3fk2 to: table1id.

	sorter := TableSorter for: (Array with: t3 with: table2 with: table1).
	self assert: sorter sort last name equals: 'T3'
]

{ #category : #tests }
GlorpCommitOrderTest >> testCommitOrderNonSequencedFieldsDontCount [
	"Test for a cycle between t1 and t2 with t3 also pointing to both, but with nothing sequenced. Order should be completely indeterminate. We rely on the topological sort being predictable and depending on the insert order so that if we feed objects with no dependencies in in different orders we should get different results."

	| t1fk t2fk t3fk t3fk2 sorter sorter2 |
	t1fk := t1 createFieldNamed: 'T2_ID' type: platform int4.
	t1 addForeignKeyFrom: t1fk to: (t2id).
	t2fk := t2 createFieldNamed: 'T1_ID' type: platform int4.
	t2 addForeignKeyFrom: t2fk to: (t1id).

	t3 := DatabaseTable new name: 'T3'.
	t3fk := t3 createFieldNamed: 'T2_ID' type: platform int4.
	t3 addForeignKeyFrom: t3fk to: (t2id).
	t3fk2 := t3 createFieldNamed: 'T1_ID' type: platform int4.
	t3 addForeignKeyFrom: t3fk2 to: (t1id).

	sorter := TableSorter for: (Array with: t3 with: t2 with: t1).
	sorter2 := TableSorter for: (Array with: t1 with: t2 with: t3).
	self assert: sorter sort first ~= sorter2 sort first
]
