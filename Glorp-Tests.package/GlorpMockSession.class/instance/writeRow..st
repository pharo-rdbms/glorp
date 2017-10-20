read/write
writeRow: aRow
	aRow shouldBeWritten ifFalse: [^true].
	aRow preWriteAssignSequencesUsing: self.
	rows add: aRow.
	aRow postWriteAssignSequencesUsing: self accessor.
	^true.