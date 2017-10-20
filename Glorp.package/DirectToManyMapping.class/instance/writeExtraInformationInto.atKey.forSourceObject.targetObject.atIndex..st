accessing
writeExtraInformationInto: aRowMap atKey: rowMapKey forSourceObject: sourceObject targetObject: targetObject atIndex: index
	super
		writeExtraInformationInto: aRowMap
		atKey: rowMapKey
		forSourceObject: sourceObject
		targetObject: targetObject
		atIndex: index.
	aRowMap
		at: self resultField
		key: rowMapKey
		put: targetObject