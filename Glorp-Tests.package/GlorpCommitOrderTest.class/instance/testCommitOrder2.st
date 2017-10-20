tests
testCommitOrder2
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
	self assert: sorter sort last name = 'T3'.