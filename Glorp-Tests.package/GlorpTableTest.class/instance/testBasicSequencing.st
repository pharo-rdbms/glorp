tests
testBasicSequencing
	| row |
	row := DatabaseRow newForTable: (system tableNamed: 'STUFF').
	row preWriteAssignSequencesUsing: nil.
	row postWriteAssignSequencesUsing: nil.
	self assert: (row at: ((system tableNamed: 'STUFF') fieldNamed: 'ID')) = 1.