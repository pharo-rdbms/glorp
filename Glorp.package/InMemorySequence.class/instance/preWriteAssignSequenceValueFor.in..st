sequencing
preWriteAssignSequenceValueFor: aField in: aRow

	aRow at: aField put: (count := count + 1).