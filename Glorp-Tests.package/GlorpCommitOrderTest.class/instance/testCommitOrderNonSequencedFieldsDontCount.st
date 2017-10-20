tests
testCommitOrderNonSequencedFieldsDontCount

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
	self assert: sorter sort first ~= sorter2 sort first.