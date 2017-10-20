tests
testTwoSequences
	| row1 row2 table idField |
	table := system tableNamed: 'STUFF'.
	row1 := DatabaseRow newForTable: table.
	row2 := DatabaseRow newForTable: table.
	row1 preWriteAssignSequencesUsing: nil.
	row1 postWriteAssignSequencesUsing: nil.
	row2 preWriteAssignSequencesUsing: nil.
	row2 postWriteAssignSequencesUsing: nil.
	idField := table fieldNamed: 'ID'.
	self assert: (row1 at: idField) = 1.
	self assert: (row2 at: idField) = 2.