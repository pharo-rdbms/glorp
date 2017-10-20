bound values
executeUnboundIn: anAccessor
	anAccessor returnRowCount: self needsRowCount.
	(self hasMultipleRows and: [self shouldUseGroupWriting not])
		ifTrue:
			[self allRows
				do:
					[:each | 
					self row: each.
					anAccessor
						executeSQLStringNoResult: self sqlString
						doing:
							[failed := failed or: [self needsRowCount and: [anAccessor rowCount ~= 1]]]
						forCommand: self.
					each postWriteAssignSequencesUsing: anAccessor]]
		ifFalse:
			[self tooBigForSingleWrite
				ifTrue:
					[self subCommands do: [:each | each executeUnboundIn: anAccessor]]
				ifFalse:
					[anAccessor
						executeSQLStringNoResult: self sqlString
						doing:
							[failed := self needsRowCount
								and: [anAccessor rowCount ~= self expectedNumberOfModifiedRows]]
						forCommand: self].
			row postWriteAssignSequencesUsing: anAccessor].
	^#() readStream.