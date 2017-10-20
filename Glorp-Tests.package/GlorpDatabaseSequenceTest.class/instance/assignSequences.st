tests
assignSequences
	| accessor |
	accessor := session isNil ifFalse: [session accessor].
	row1 preWriteAssignSequencesUsing: session.
	row1 postWriteAssignSequencesUsing: accessor.
	row2 preWriteAssignSequencesUsing: session.
	row2 postWriteAssignSequencesUsing: accessor