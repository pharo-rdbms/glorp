public
getSequenceValueFromDatabaseFor: aField in: aRow using: aSession

	aRow at: aField put: (count := count + 1).