sequencing
postWriteAssignSequencesUsing: anAccessor

	self table fields do: [:each |
		(self hasValueFor: each) ifFalse: [
			each type postWriteAssignSequenceValueFor: each in: self using: anAccessor]].