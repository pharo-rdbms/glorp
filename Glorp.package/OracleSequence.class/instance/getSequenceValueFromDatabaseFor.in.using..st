public
getSequenceValueFromDatabaseFor: aField in: aRow using: anAccessor 
	aRow at: aField put: (self nextSequenceNumber: anAccessor)