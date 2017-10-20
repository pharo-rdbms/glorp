executing
executeBoundIn: anAccessor
	| result |
	(self hasMultipleRows and: [self shouldUseGroupWriting not])
		ifTrue:
			[self allRows
				do:
					[:each | 
					self row: each.
					result := anAccessor executeCommandBound: self.
					result release.
					failed := failed or: [self needsRowCount and: [rowCount ~= 1]].
					each postWriteAssignSequencesUsing: anAccessor]]
		ifFalse:
			[result := anAccessor executeCommandBound: self.
			result release.
			failed := self needsRowCount and: [rowCount ~= self expectedNumberOfModifiedRows].
			row postWriteAssignSequencesUsing: anAccessor].
	"Results aren't interesting"
	^ anAccessor cursorFor: #() readStream