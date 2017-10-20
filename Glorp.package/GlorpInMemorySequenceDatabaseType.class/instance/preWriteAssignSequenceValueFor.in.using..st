SQL
preWriteAssignSequenceValueFor: aDatabaseField in: aDatabaseRow using: anAccessor

	aDatabaseRow at: aDatabaseField put: (self class next)