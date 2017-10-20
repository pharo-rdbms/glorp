private/mapping
assignSequenceNumbers
	commitPlan do: [:each | each preWriteAssignSequencesUsing: self session].