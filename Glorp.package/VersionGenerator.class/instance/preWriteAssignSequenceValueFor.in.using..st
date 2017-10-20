sequencing
preWriteAssignSequenceValueFor: aField in: aRow using: anAccessor
	"Overwrite a pre-existing value in the field if necessary"
	aRow at: aField forcePut: (self nextValueFor: aField in: aRow).