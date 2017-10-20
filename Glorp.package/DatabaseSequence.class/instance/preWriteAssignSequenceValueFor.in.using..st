sequencing
preWriteAssignSequenceValueFor: aField in: aRow using: anAccessor
	self hasReservedNumbers
		ifTrue: [aRow at: aField put: self nextReservedNumber]
		ifFalse:
			[self
				getSequenceValueFromDatabaseFor: aField
				in: aRow
				using: anAccessor].